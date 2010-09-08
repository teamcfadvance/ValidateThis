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
<cfcomponent extends="validatethis.tests.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("InList");
			parameters = {list="milk,cookies,ice cream",delim=","};
			validation.hasParameter("delim").returns(true);
			validation.getParameterValue("delim").returns(parameters.delim);
			shouldFail = ["beer","burgers","cheese","chips"];
			shouldPass = ["milk","cookies","ice cream"];
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForExamplesThatShouldPass" access="public" returntype="void" mxunit:dataprovider="shouldPass">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			setup();
			validation.getParameters().returns(parameters);
			validation.hasParameter("list").returns(true);
			validation.getParameterValue("list").returns(parameters.list);
			validation.getObjectValue().returns(arguments.value);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForExamplesThatShouldNotPass" access="public" returntype="void" mxunit:dataprovider="shouldFail">
		<cfargument name="value" hint="each item in the shouldFail dataprovider array" />
		<cfscript>
			setup();
			validation.getParameters().returns(parameters);
			validation.hasParameter("list").returns(true);
			validation.getParameterValue("list").returns(parameters.list);
			validation.getObjectValue().returns(arguments.value);
			debug(arguments.value);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("");
			validation.getParameters().returns(parameters);
			validation.hasParameter("list").returns(true);
			validation.getParameterValue("list").returns(parameters.list);
			validation.getIsRequired().returns(false);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Overriding this as it actually should return true.">
		<cfscript>
			validation.getObjectValue().returns("");
			validation.getParameters().returns(parameters);
			validation.hasParameter("list").returns(true);
			validation.getParameterValue("list").returns(parameters.list);
			validation.getIsRequired().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
