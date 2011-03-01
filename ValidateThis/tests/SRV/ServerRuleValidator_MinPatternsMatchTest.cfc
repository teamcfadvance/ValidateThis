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
<cfcomponent extends="validatethis.tests.SRV.BaseForServerRuleValidatorTestsWithDataproviders" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("MinPatternsMatch");
			parameters = {minMatches=1,pattern_Name="[a-z]]"};
			shouldPass = ["a"];
			shouldFail = ["NotAGoodTest","FailTest"];
		</cfscript>
	</cffunction>
	
	
	<!--- TODO: Fix Test --->
	<cffunction name="validateReturnsTrueForExamplesThatShouldPass" access="public" returntype="void" mxunit:dataprovider="shouldPass">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			super.setup();
            objectValue = arguments.value;

            configureValidationMock();
			validation.getParameterValue("minMatches",1).returns(0);
			validation.getParameterValue("pattern_Name").returns("[a-z]]");
			SRV.validate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForExamplesThatShouldNotPass" access="public" returntype="void" mxunit:dataprovider="shouldFail">
		<cfargument name="value" hint="each item in the shouldFail dataprovider array" />
		<cfscript>
			super.setup();
			objectValue = arguments.value;

            configureValidationMock();

			validation.getParameterValue("minMatches",1).returns(1);
			validation.getParameterValue("pattern_Name").returns("test");

			SRV.validate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Overriding this as it actually should return true.">
		<cfscript>
			super.setup();
			objectValue = "";
			isRequired = true;
            
            configureValidationMock();
            
            validation.getParameterValue("minMatches",1).returns(1);
            validation.getParameterValue("pattern_Name").returns("^(test)");
            
			SRV.validate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>

