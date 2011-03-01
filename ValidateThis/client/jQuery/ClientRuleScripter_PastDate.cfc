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
<cfcomponent output="false" name="ClientRuleScripter_PastDate" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the past date validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The date entered must be in the past." />
		<cfset var theCondition="function(value,element,options) { return true; }" />
		
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
			function(value,element,options) { var dBefore = new Date(); var dValue = new Date(value); if (options.before) { dBefore = new Date(options.before); } return (dBefore > dValue); } 
		</cfsavecontent>
		
		<cfreturn generateAddMethod(theCondition,arguments.defaultMessage) />
	</cffunction>

	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var options = true />
		<cfif arguments.validation.hasParameter("before")>
			<cfset options = {}/>
			<cfset options["before"] = arguments.validation.getParameterValue("before") />
		</cfif>
		<cfreturn serializeJSON(options) />
	</cffunction>

	<cffunction name="getDefaultFailureMessage" returntype="any" access="private" output="false">
		<cfargument name="validation" type="any"/>
		<cfset var failureMessage = createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must be a date in the past.") />
		<cfif arguments.validation.hasParameter("before")>
			<cfset failureMessage = failureMessage & " The date entered must come before #arguments.validation.getParameterValue('before')#." />
		</cfif>
		<cfreturn failureMessage />
	</cffunction>

</cfcomponent>
