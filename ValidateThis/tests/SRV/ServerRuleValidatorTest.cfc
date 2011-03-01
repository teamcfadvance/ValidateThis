<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
--->
<cfcomponent extends="validatethis.tests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="defaultFailureMessagesShouldBePrependedWithTheDefaultPrefix" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("required");
			objectValue = "";
			failureMessage = "The PropertyDesc is required.";
            
            configureValidationMock();			
            
			SRV.validate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>

	<cffunction name="defaultFailureMessagesShouldBePrependedWithTheOverriddenPrefix" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("required","");
			objectValue = "";
            failureMessage = "PropertyDesc is required.";
            
            configureValidationMock();         
            
            SRV.validate(validation);
            validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyHasValueShouldReturnTrueIfPropertyPopulated" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("required");
			validation.getObjectValue().returns("Something");
			makePublic(SRV,"propertyHasValue");
			assertEquals(true,SRV.propertyHasValue(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyHasValueShouldReturnFalseIfPropertyNotPopulated" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("required");
			validation.getObjectValue().returns("");
			makePublic(SRV,"propertyHasValue");
			assertEquals(false,SRV.propertyHasValue(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(true);
			makePublic(SRV,"propertyIsRequired");
			assertEquals(true,SRV.propertyIsRequired(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredShouldReturnFalseIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(false);
			makePublic(SRV,"propertyIsRequired");
			assertEquals(false,SRV.propertyIsRequired(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(true);
			validation.getObjectValue().returns("");
			makePublic(SRV,"shouldTest");
			assertEquals(true,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnTrueIfPropertyHasValue" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(false);
			validation.getObjectValue().returns("Something");
			makePublic(SRV,"shouldTest");
			assertEquals(true,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnTrueIfPropertyHasValueAndIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(true);
			validation.getObjectValue().returns("Something");
			makePublic(SRV,"shouldTest");
			assertEquals(true,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnFalseIfPropertyNotPopulatedAndNotRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(false);
			validation.getObjectValue().returns("");
			makePublic(SRV,"shouldTest");
			assertEquals(false,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<!---
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
	--->

	<cffunction name="validate" access="private" returntype="Any">
		<cfargument name="theObject" />
		<cfargument name="validation" />
		<cfargument name="Parameters" required="false" default="#StructNew()#" />
		<cfargument name="Condition" required="false" default="#StructNew()#" />
		<cfargument name="PropertyName" required="false" default="FirstName" />
		<cfargument name="PropertyDesc" required="false" default="First Name" />
		
		<cfset Validation = CreateObject("component","ValidateThis.core.validation").init(arguments.theObject,ObjectChecker).load(arguments) />
		<cfset CreateObject("component","ValidateThis.server.ServerRuleValidator_#arguments.validation#").init(ObjectChecker).validate(Validation) />
		<cfreturn Validation />
		
	</cffunction>

</cfcomponent>


