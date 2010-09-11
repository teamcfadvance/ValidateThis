<!---
	
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			
			// What needs to be mocked to test SRVs?
			ObjectChecker = mock(); 	// see  util/ObjectChecker.cfc
			validation = mock();		// see  core/Validation.cfc
			theObject = mock(); 		// see 			
			validateThis = mock();
			
			mockFacade=false;
			
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			
			//Default Validation Mock Values
			propertyDesc="PropertyDesc";
			propertyName="PropertyName";
			parameters={};
			objectValue = "";
			isRequired = true;
			failureMessage = "";
			
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="facadeMockup" access="private">
		<cfscript>
  		   // Integration Testing
			VTConfig = {definitionPath="/validatethis/tests/Fixture/models/cf9"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			
		</cfscript>
	</cffunction>
	
	<cffunction name="validationMockup" access="private">
		<cfscript>

			if (mockfacade eq true){
				facadeMockup();
			}

			validation.setIsSuccess(false).returns();
			validation.getValidateThis().returns(ValidateThis);
			validation.getPropertyDesc().returns(propertyDesc);
			validation.getPropertyName().returns(propertyName);
			validation.getFailureMessage().returns(failureMessage);
			validation.setFailureMessage(failureMessage).returns();
			validation.getIsRequired().returns(isRequired);
			validation.getParameters().returns(parameters);
			validation.getObjectValue().returns(objectValue);
			validation.getTheObject().returns(theObject);
		</cfscript>
	</cffunction>
	
	<cffunction name="validationMockupReturnsValidateThisWithOtherSRVSLoaded" access="public" returntype="void">
		<cfscript>
			validationMockup();
			
			if (mockfacade eq true){
				srvs = validation.getValidateThis().getServerRuleValidators();
				debug(structCount(srvs));
				assertTrue(structCount(srvs) gt 0);
				assertTrue(structCount(srvs) eq 29);
				assertTrue(structCount(validation.getValidateThis().getServerRuleValidators()) gt 0);
			}
		</cfscript>  
	</cffunction>
	
	<!--- These two tests will be identical for each SRV, but should be run for each --->
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			isRequired=false;
			failureMessage = "";
			
			validationMockup();			
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			isRequired = true;
			failureMessage = "";
			
			validationMockup();
			
			SRV.validate(validation);			
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="getSRV" access="private" returntype="Any">
		<cfargument name="validation" />
		<cfargument name="defaultFailureMessagePrefix" required="false" default="The " />
		
		<cfreturn CreateObject("component","ValidateThis.server.ServerRuleValidator_#arguments.validation#").init(arguments.defaultFailureMessagePrefix) />
		
	</cffunction>

</cfcomponent>
