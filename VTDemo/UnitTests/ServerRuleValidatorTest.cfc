<!---
	
filename:		\VTDemo\UnitTests\ServerRuleValidatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ServerRuleValidatorTest.cfc
				
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
<cfcomponent displayname="UnitTests.ServerRuleValidatorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset theObject = "" />
	<cfset TransientFactory = "" />
	<cfset ServerValidator = ""/>
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			setBeanFactory();
			Transfer = getBeanFactory().getBean("Transfer");
			theObject = Transfer.new("user.user");
			TransientFactory = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory");
			ServerValidator = getBeanFactory().getBean("ValidateThis").getBean("ServerValidator");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="SimpleRequiredValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew();
			theValue = "Bob";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Required").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Required").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# is required.");
		</cfscript>  
	</cffunction>

	<cffunction name="MinLengthValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct = StructNew();
			valStruct.ValType = "minlength";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.minlength = theLength;
			valStruct.Condition = "";
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("MinLength").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("MinLength").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be at least #theLength# characters long.");
		</cfscript>  
	</cffunction>

	<cffunction name="MaxLengthValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct = StructNew();
			valStruct.ValType = "maxlength";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.maxlength = theLength;
			valStruct.Condition = "";
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("MaxLength").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "BobbyS";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("MaxLength").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be no more than #theLength# characters long.");
		</cfscript>  
	</cffunction>

	<cffunction name="RangeLengthValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			minLength = 5;
			maxLength = 10;
			valStruct = StructNew();
			valStruct.ValType = "rangelength";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.minlength = minLength;
			valStruct.Parameters.maxlength = maxLength;
			valStruct.Condition = "";
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("RangeLength").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "Bob";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("RangeLength").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be between #MinLength# and #MaxLength# characters long.");
			theValue = "BobbyBobbyX";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("RangeLength").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be between #MinLength# and #MaxLength# characters long.");
		</cfscript>  
	</cffunction>

	<cffunction name="MinValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct = StructNew();
			valStruct.ValType = "min";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.min = theVal;
			valStruct.Condition = "";
			theValue = "5";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Min").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "4";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Min").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be at least #theVal#.");
		</cfscript>  
	</cffunction>

	<cffunction name="MaxValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct = StructNew();
			valStruct.ValType = "max";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.max = theVal;
			valStruct.Condition = "";
			theValue = "5";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Max").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "6";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Max").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be no more than #theVal#.");
		</cfscript>  
	</cffunction>

	<cffunction name="RangeValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			valStruct = StructNew();
			valStruct.ValType = "range";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.min = min;
			valStruct.Parameters.max = max;
			valStruct.Condition = "";
			theValue = "5";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Range").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "3";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Range").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be between #Min# and #Max#.");
			theValue = "11";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("Range").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be between #Min# and #Max#.");
		</cfscript>  
	</cffunction>

	<cffunction name="EqualToValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct = StructNew();
			valStruct.ValType = "EqualTo";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.ComparePropertyName = ComparePropertyName;
			valStruct.Parameters.ComparePropertyDesc = ComparePropertyDesc;
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			theObject.setLastName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("EqualTo").init().validate(Validation);
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "Bob";
			theObject.setLastName(theValue);
			Validation = TransientFactory.newValidation(theObject).load(valStruct);
			Validator = ServerValidator.getRuleValidator("EqualTo").init().validate(Validation);
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #valStruct.PropertyDesc# must be the same as the #ComparePropertyDesc#.");
		</cfscript>  
	</cffunction>

</cfcomponent>

