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
<cfcomponent output="false" name="ClientRuleScripter_equalTo" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the equalTo validation.">

	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="Any" required="yes" />
		<cfargument name="customMessage" type="Any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var safeFormName = variables.getSafeFormName(arguments.formName) />
		<cfset var fieldSelector = "$form_#safeFormName#.find("":input[name='#arguments.validation.getClientFieldName()#']"")" />
		<cfset var options = true/>
		<cfset var messageScript = "" />
		<cfset var propertyName=arguments.validation.getParameterValue('ComparePropertyName')>
		<cfset var propertyDesc=arguments.validation.getParameterValue('ComparePropertyDesc')>
		
		<cfif Len(arguments.customMessage) eq 0>
			<cfset arguments.customMessage = createDefaultFailureMessage("#validation.getPropertyDesc()# must be the same as #lCase(arguments.defaultFailureMessagePrefix)##propertyDesc#.") />
		</cfif>
		<cfset messageScript = variables.Translator.translate(arguments.customMessage,arguments.locale)/>
		
		<cfoutput>
		<cfsavecontent variable="theScript">
		#fieldSelector#.rules("add",{equalTo:":input[name='#propertyName#']",messages:{equalTo:"#messageScript#"}});
		</cfsavecontent>
		</cfoutput>

		<cfreturn trim(theScript)/>
	</cffunction>

</cfcomponent>
