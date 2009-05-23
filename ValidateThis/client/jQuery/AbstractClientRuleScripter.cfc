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
<cfcomponent output="false" name="AbstractClientRuleScripter" hint="I am a base object which all concrete ClientRuleScripters extend.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientRuleScripter">
		<cfargument name="Translator" type="Any" required="yes" />
		<cfset variables.Translator = arguments.Translator />
		<cfreturn this />
	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfreturn generateAddRule(validation=arguments.validation,locale=arguments.locale) />
		
	</cffunction>

	<cffunction name="generateAddRule" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="ruleDef" type="any" required="no" default="#arguments.validation.ValType#: true" hint="The JS object that describes a rule to add to the DOM object." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var customMessage = "" />
		<cfif StructKeyExists(arguments.validation,"failureMessage")>
			<cfset customMessage = ", messages: {#ListFirst(arguments.ruleDef,':')#: '#JSStringFormat(variables.Translator.translate(arguments.validation.failureMessage,arguments.locale))#'}" />
		</cfif>
		<cfreturn "$(""###arguments.validation.ClientFieldName#"").rules('add',{#arguments.ruleDef##customMessage#});" />
		
	</cffunction>

	<cffunction name="generateAddMethod" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="theCondition" type="any" required="yes" hint="The conditon to test." />
		<cfargument name="theMessage" type="any" required="no" default="" hint="A custom message to display on failure." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var fieldName = arguments.validation.ClientFieldName />
		<cfset var valType = arguments.validation.ValType />
		<cfif Len(arguments.theMessage)>
			<cfset messageScript = ', "' & variables.Translator.translate(arguments.theMessage,arguments.locale) & '"' />
		</cfif>

		<cfsavecontent variable="theScript">
			<cfoutput>
				$.validator.addMethod("#fieldName##valType#", $.validator.methods.#valType##messageScript#);
				$.validator.addClassRules("#fieldName##valType#", {#fieldName##valType#: #arguments.theCondition#});
				$("###fieldName#").addClass('#fieldName##valType#');
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />
		
	</cffunction>

</cfcomponent>


