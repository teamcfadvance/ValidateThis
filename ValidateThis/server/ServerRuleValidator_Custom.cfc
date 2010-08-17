<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_Custom" extends="AbstractServerRuleValidator" hint="I am responsible for performing a custom validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />

		<cfset var customResult = 0 />
		<cfset var failureMessage = "A custom validator failed." />
		<cfset var theObject = arguments.valObject.getTheObject() />
		<cfset var Parameters = arguments.valObject.getParameters() />
		<cfset var theMethod = Parameters.MethodName />
		
		<cfset customResult = evaluate("theObject.#theMethod#()") />
		<cfif NOT IsDefined("customResult")>
			<cfreturn />
		</cfif>
		<cfif (isBoolean(customResult) and customResult) or (isStruct(customResult) and customResult.IsSuccess)>
			<cfreturn />
		</cfif>
		<cfif isStruct(customResult) and structKeyExists(customResult,"failureMessage")>
			<cfset failureMessage = customResult.failureMessage />
		<cfelseif len(arguments.valObject.getFailureMessage()) GT 0>
			<cfset failureMessage = arguments.valObject.getFailureMessage() /> 
		</cfif>
		<cfset fail(arguments.valObject,failureMessage) />
	</cffunction>

</cfcomponent>
	
