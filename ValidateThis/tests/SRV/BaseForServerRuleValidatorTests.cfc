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
			
			// local variables used by common tests and methods
			needsFacade=false;
			emptyValueShouldFail = true;
			
			// mocks used
			validation = mock();		// see  core/Validation.cfc
			theObject = mock();
			validateThis = "";
			
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
	
	<cffunction name="createRealFacade" access="private">
		<cfscript>
  		   // Integration Testing
			VTConfig = {definitionPath="/validatethis/tests/Fixture/models/cf9"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
		<cfscript>

			if (needsFacade eq true){
				createRealFacade();
			}

			//validation.setIsSuccess(false).returns();
			validation.getValidateThis().returns(ValidateThis);
			validation.getPropertyDesc().returns(propertyDesc);
			validation.getPropertyName().returns(propertyName);
			validation.getClientFieldName().returns(propertyName);
			validation.getFailureMessage().returns(failureMessage);
			if (len(failureMessage)) {
				validation.fail(failureMessage).returns();
			} else {
				validation.fail("{*}").returns();
			}
			validation.getIsRequired().returns(isRequired);
			validation.getParameters().returns(parameters);
			validation.getObjectValue().returns(objectValue);
			validation.getTheObject().returns(theObject);
		</cfscript>
	</cffunction>
	
	<!--- These two tests will be identical for each SRV, but should be run for each --->
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			isRequired=false;
			failureMessage = "";
			
			configureValidationMock();			
			
			SRV.validate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			isRequired = true;
			failureMessage = "";
			
			configureValidationMock();
			
			SRV.validate(validation);
			if (emptyValueShouldFail) {
				validation.verifyTimes(1).fail("{*}");
			} else { 
				validation.verifyTimes(0).fail("{*}");
			}	
		</cfscript>  
	</cffunction>
	
	<cffunction name="getSRV" access="private" returntype="Any">
		<cfargument name="validation" />
		<cfargument name="defaultFailureMessagePrefix" required="false" default="The " />
		
		<cfreturn CreateObject("component","ValidateThis.server.ServerRuleValidator_#arguments.validation#").init(arguments.defaultFailureMessagePrefix) />
		
	</cffunction>

</cfcomponent>
