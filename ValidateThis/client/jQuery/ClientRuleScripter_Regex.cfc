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
<cfcomponent output="false" name="ClientRuleScripter_Regex" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the regex validation.">

	<cffunction name="getRuleDef" returntype="any" access="private" output="false" hint="I return just the rule definition which is required for the generateAddRule method.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfset var theRegex = "" />

		<cfif StructKeyExists(arguments.validation.Parameters,"ServerRegex")>
			<cfset theRegex = arguments.validation.Parameters.ServerRegex />
		<cfelseif StructKeyExists(arguments.validation.Parameters,"Regex")>
			<cfset theRegex = arguments.validation.Parameters.Regex />
		<cfelse>			
			<cfthrow type="validatethis.client.jQuery.ClientRuleScripter_Regex.missingParameter"
			message="Either a regex or a serverRegex parameter must be defined for a regex rule type." />
		</cfif>

		<cfreturn "regex: /#theRegex#/" />
		
	</cffunction>

</cfcomponent>


