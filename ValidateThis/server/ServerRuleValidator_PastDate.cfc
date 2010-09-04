<!---
	
	Copyright 2008, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_PastDate" extends="AbstractServerRuleValidator" hint="I am responsible for performing the past date validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfset var theVal = arguments.valObject.getObjectValue()/>
		<cfset var theDate = now()/>
		<cfset var parameterMessages = ""/>
		
		<cfif arguments.valObject.hasParameter("before")>
			<cfset theDate = arguments.valObject.getParameterValue("before")/>
			<cfset parameterMessages = " The date entered must come before #theDate#">
		</cfif>
		
		<cfif shouldTest(arguments.valObject) AND not isDate(theVal) or not dateCompare(theVal,theDate) eq -1>
			<cfset fail(arguments.valObject,createDefaultFailureMessage("#arguments.valObject.getPropertyDesc()# must be a date in the past.#parameterMessages#")) />
		</cfif>
	</cffunction>
	
</cfcomponent>