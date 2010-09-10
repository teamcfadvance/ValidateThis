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
			ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");

			// Define Validation Mockup Test Values
			parameters={};
			objectValue = "";
			isRequired = true;
			failureMessage = "";
            
            theObject = mock();
            validation = mock();
            
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="validationMockup" access="private">
		<cfscript>			
            validation.setIsSuccess(false).returns();
            validation.getPropertyDesc().returns("PropertyDesc");
            validation.getFailureMessage().returns(failureMessage);
            validation.setFailureMessage(failureMessage).returns();
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


