<!---
	
filename:		\VTDemo\UnitTests\ValidationFactoryTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ValidationFactoryTest.cfc
				
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
<cfcomponent displayname="UnitTests.ValidateThisTest" extends="UnitTests.BaseTestCase" output="false">
	
	<!--- TODO: Change these tests to use Reactor --->
	
	<cfset ValidateThis = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory(baseBeanPath="/ServiceDemo/model/config/Coldspring.xml.cfm")>
		<cfset ValidateThis = getBeanFactory().getBean("ValidateThis") />
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="setUpUser" access="private" returntype="any">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user_no_decorator");
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

	<cffunction name="ValidateThisContainsComposedObjects" access="public" returntype="void">
		<cfscript>
			assertTrue(GetMetadata(ValidateThis.getTransientFactory()).name CONTAINS "TransientFactory");
			assertTrue(GetMetadata(ValidateThis.variables.ValidationFactory).name CONTAINS "ValidationFactory");
		</cfscript>  
	</cffunction>

	<cffunction name="newResultReturnsResultObject" access="public" returntype="void">
		<cfscript>
			Result = ValidateThis.newResult();
			assertTrue(GetMetadata(Result).name CONTAINS "Result");
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsResultObject" access="public" returntype="void">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user_no_decorator");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO);
			assertTrue(GetMetadata(Result).name CONTAINS "Result");
		</cfscript>  
	</cffunction>

	<cffunction name="ValidateFailsWithCorrectMessages" access="public" returntype="void">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user_no_decorator");
			UserTO.setVerifyPassword("Something that won't match");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Register");
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
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
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
			UserTO = Transfer.new("user.user_no_decorator");
			UserTO.setUserName("AnInvalidEmailAddress");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Register");
			Failures = Result.getFailures();
			Failure = Failures[1];
			AssertEquals(Failure.Message,"Hey, buddy, you call that an Email Address?");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyWithoutValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			UserTO = setUpUser();
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Register");
			AssertTrue(Result.getIsSuccess());
			UserTO.setFirstName("");
			UserTO.setLastName("");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Register");
			AssertTrue(Result.getIsSuccess());
			UserTO.setFirstName("Bob");
			UserTO.setLastName("");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Register");
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
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			AssertTrue(Result.getIsSuccess());
			UserTO.setAllowCommunication(1);
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"CommunicationMethod");
			assertEquals(Failure.Message,"If you are allowing communication, you must choose a communication method.");
			UserTO.setCommunicationMethod("Email");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="ServerConditionShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			UserTO = setUpUser();
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			AssertTrue(Result.getIsSuccess());
			UserTO.setLikeCheese(0);
			UserTO.setLikeChocolate(0);
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			UserTO.setLikeOther("Cake");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="getRequiredPropertiesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			FieldList = ValidateThis.getRequiredProperties(className="user.user_no_decorator",context="Register");
			debug(FieldList);
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
		</cfscript>  
	</cffunction>

	<cffunction name="getAllContextsReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			AllContexts = ValidateThis.getAllContexts(className="user.user_no_decorator");
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="GetErrorsForMGReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			Transfer = getBeanFactory().getBean("Transfer");
			UserTO = Transfer.new("user.user_no_decorator");
			UserTO.setVerifyPassword("Something that won't match");
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Register");
			Errors = Result.getErrors();
			assertEquals(StructCount(Errors),5);
			assertEquals(ArrayLen(Errors.LikeOther),1);
			assertEquals(ArrayLen(Errors.UserGroupId),1);
			assertEquals(ArrayLen(Errors.UserName),1);
			assertEquals(ArrayLen(Errors.UserPass),2);
			assertEquals(ArrayLen(Errors.VerifyPassword),1);
			Result = ValidateThis.validate("user.user_no_decorator",UserTO,"Profile");
			Errors = Result.getErrors();
			assertEquals(StructCount(Errors),8);
			assertEquals(ArrayLen(Errors.LikeOther),1);
			assertEquals(ArrayLen(Errors.UserGroupId),1);
			assertEquals(ArrayLen(Errors.UserName),1);
			assertEquals(ArrayLen(Errors.UserPass),2);
			assertEquals(ArrayLen(Errors.VerifyPassword),1);
			assertEquals(ArrayLen(Errors.FirstName),1);
			assertEquals(ArrayLen(Errors.LastName),1);
			assertEquals(ArrayLen(Errors.Salutation),1);
		</cfscript>  
	</cffunction>

</cfcomponent>

