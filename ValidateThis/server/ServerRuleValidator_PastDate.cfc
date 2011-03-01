<!---
	
	Copyright 2010, Adam Drew
	
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
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfset var theVal = arguments.validation.getObjectValue()/>
		<cfset var theDate = now()/>
		<cfset var parameterMessages = ""/>
		
		<cfif arguments.validation.hasParameter("before")>
			<cfset theDate = arguments.validation.getParameterValue("before")/>
			<cfset parameterMessages = " The date entered must come before #theDate#.">
		</cfif>
		
		<cfif shouldTest(arguments.validation) AND (not isValid("date",theVal) OR (isValid("date",theVal) AND not dateCompare(theVal,theDate) eq -1))>
			<cfset fail(arguments.validation,createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must be a date in the past.#parameterMessages#")) />
		</cfif>
	</cffunction>
	
</cfcomponent>