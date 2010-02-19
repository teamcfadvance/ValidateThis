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
			theObject = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			// ObjectChecker.findGetter("{any}","FirstName").returns("getFirstName()");
			// ObjectChecker.findGetter("{any}","LastName").returns("getLastName()");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="SimpleRequiredValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theValue = "Bob";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"required");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"required");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# is required.");
			// just checking to see if the isInstanceOf thing is going to work
			debug(isInstanceOf(theObject, 'java.lang.Object'));
		</cfscript>  
	</cffunction>

	<cffunction name="MinLengthValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			Parameters = {minlength = theLength};
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"minlength",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"minlength",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be at least #theLength# characters long.");
		</cfscript>  
	</cffunction>

	<cffunction name="MaxLengthValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			Parameters = {maxlength = theLength};
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"maxlength",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "BobbyS";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"maxlength",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be no more than #theLength# characters long.");
		</cfscript>  
	</cffunction>

	<cffunction name="RangeLengthValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			minLength = 5;
			maxLength = 10;
			Parameters = {minlength = minLength, maxlength = maxLength};
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"rangelength",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "Bob";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"rangelength",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be between #MinLength# and #MaxLength# characters long.");
			theValue = "BobbyBobbyX";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"rangelength",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be between #MinLength# and #MaxLength# characters long.");
		</cfscript>  
	</cffunction>

	<cffunction name="MinValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			Parameters = {min = theVal};
			theValue = "5";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"min",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "4";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"min",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be at least #theVal#.");
		</cfscript>  
	</cffunction>

	<cffunction name="MaxValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			Parameters = {max = theVal};
			theValue = "5";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"max",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "6";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"max",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be no more than #theVal#.");
		</cfscript>  
	</cffunction>

	<cffunction name="RangeValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			Parameters = {min = min, max = max};
			theValue = "5";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"range",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "3";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"range",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be between #Min# and #Max#.");
			theValue = "11";
			theObject.setFirstName(theValue);
			Validation = validate(theObject,"range",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be between #Min# and #Max#.");
		</cfscript>  
	</cffunction>

	<cffunction name="EqualToValidationShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			// cannot seem to get mock objectChecker to work with call to two getters, so using the real one
			objectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init();
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			Parameters = {ComparePropertyName = ComparePropertyName, ComparePropertyDesc = ComparePropertyDesc};
			theValue = "Bobby";
			theObject.setFirstName(theValue);
			theObject.setLastName(theValue);
			Validation = validate(theObject,"EqualTo",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theValue = "Bob";
			theObject.setLastName(theValue);
			Validation = validate(theObject,"EqualTo",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"The #Validation.getPropertyDesc()# must be the same as the #ComparePropertyDesc#.");
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationOnCFCShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			methodName = "customMethod";
			Parameters = {methodName = methodName};
			theObject.setCustomReturn(true);
			Validation = validate(theObject,"Custom",Parameters,"");
			assertTrue(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"");
			theObject.setCustomReturn(false);
			Validation = validate(theObject,"Custom",Parameters,"");
			assertFalse(Validation.getIsSuccess());
			assertEquals(Validation.getFailureMessage(),"No!");
		</cfscript>  
	</cffunction>

	<cffunction name="validate" access="private" returntype="Any">
		<cfargument name="theObject" />
		<cfargument name="ValType" />
		<cfargument name="Parameters" required="false" default="#StructNew()#" />
		<cfargument name="Condition" required="false" default="#StructNew()#" />
		<cfargument name="PropertyName" required="false" default="FirstName" />
		<cfargument name="PropertyDesc" required="false" default="First Name" />
		
		<cfset Validation = CreateObject("component","ValidateThis.server.validation").init(arguments.theObject,ObjectChecker).load(arguments) />
		<cfset CreateObject("component","ValidateThis.server.ServerRuleValidator_#arguments.valType#").init(ObjectChecker).validate(Validation) />
		<cfreturn Validation />
		
	</cffunction>


</cfcomponent>


