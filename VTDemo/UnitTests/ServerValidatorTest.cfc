<!---
	
filename:		\VTDemo\UnitTests\ServerValidatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ServerValidatorTest.cfc
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	2008-10-22	New																		BS

--->
<cfcomponent displayname="UnitTests.ServerValidatorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset ServerValidator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory() />
		<cfset ServerValidator = getBeanFactory().getBean("ValidateThis").getBean("ServerValidator") />
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="setUpUser" access="private" returntype="any">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user");
			UserTO.setUserName("bob.silverberg@gmail.com");
			UserTO.setUserPass("Bobby");
			UserTO.setVerifyPassword("Bobby");
			UserTO.setSalutation("Mr.");
			UserTO.setFirstName("Bob");
			UserTO.setLastName("Silverberg");
			UserTO.setLikeCheese(1);
			UserTO.setUserGroup(Transfer.new("user.usergroup"));
			return UserTO;
		</cfscript>
	</cffunction>


	<cffunction name="RuleValidatorsShouldBeLoadedCorrectly" access="public" returntype="void">
		<cfscript>
			RuleValidators = ServerValidator.getRuleValidators();
			assertTrue(IsStruct(RuleValidators));
			assertTrue(GetMetadata(RuleValidators.Custom).name CONTAINS "ServerRuleValidator_Custom");
			assertTrue(GetMetadata(RuleValidators.Required).name CONTAINS "ServerRuleValidator_Required");
			assertTrue(StructKeyExists(RuleValidators.Required,"validate"));
		</cfscript>  
	</cffunction>

	<cffunction name="ValidateFailsWithCorrectMessages" access="public" returntype="void">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user");
			UserTO.setVerifyPassword("Something that won't match");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Register",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			assertEquals(ArrayLen(Failures),6);
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserName");
			assertEquals(Failure.Message,"The Email Address is required.");
			Failure = Failures[2];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password is required.");
			Failure = Failures[3];
			assertEquals(Failure.Type,"rangelength");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password must be between 5 and 10 characters long.");
			Failure = Failures[4];
			assertEquals(Failure.Type,"equalTo");
			assertEquals(Failure.PropertyName,"VerifyPassword");
			assertEquals(Failure.Message,"The Verify Password must be the same as the Password.");
			Failure = Failures[5];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserGroup");
			assertEquals(Failure.Message,"The User Group is required.");
			Failure = Failures[6];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			assertEquals(ArrayLen(Failures),9);
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"Salutation");
			assertEquals(Failure.Message,"The Salutation is required.");
			Failure = Failures[2];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"FirstName");
			assertEquals(Failure.Message,"The First Name is required.");
			Failure = Failures[3];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LastName");
			assertEquals(Failure.Message,"The Last Name is required.");
			Failure = Failures[4];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserName");
			assertEquals(Failure.Message,"The Email Address is required.");
			Failure = Failures[5];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password is required.");
			Failure = Failures[6];
			assertEquals(Failure.Type,"rangelength");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password must be between 5 and 10 characters long.");
			Failure = Failures[7];
			assertEquals(Failure.Type,"equalTo");
			assertEquals(Failure.PropertyName,"VerifyPassword");
			assertEquals(Failure.Message,"The Verify Password must be the same as the Password.");
			Failure = Failures[8];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserGroup");
			assertEquals(Failure.Message,"The User Group is required.");
			Failure = Failures[9];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideMessageShouldGeneratesCorrectMessage" access="public" returntype="void">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user");
			UserTO.setUserName("AnInvalidEmailAddress");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Register",Result);
			Failures = Result.getFailures();
			debug(failures);
			Failure = Failures[1];
			AssertEquals(Failure.Message,"Hey, buddy, you call that an Email Address?");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyWithoutValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			UserTO = setUpUser();
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Register",Result);
			AssertTrue(Result.getIsSuccess());
			UserTO.setFirstName("");
			UserTO.setLastName("");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Register",Result);
			AssertTrue(Result.getIsSuccess());
			UserTO.setFirstName("Bob");
			UserTO.setLastName("");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Register",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LastName");
			assertEquals(Failure.Message,"The Last Name is required if you specify a value for the First Name.");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyWithValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			UserTO = setUpUser();
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			UserTO.setAllowCommunication(1);
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"CommunicationMethod");
			assertEquals(Failure.Message,"If you are allowing communication, you must choose a communication method.");
			UserTO.setCommunicationMethod("Email");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="ServerConditionShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			UserTO = setUpUser();
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			UserTO.setLikeCheese(0);
			UserTO.setLikeChocolate(0);
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			UserTO.setLikeOther("Cake");
			Result = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory").newResult();
			ServerValidator.validate(UserTO.getValidator(),UserTO,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

</cfcomponent>

