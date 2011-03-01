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
	<cfproperty name="DefaultFailureMessage" type="string" default="">
	
	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientRuleScripter">
		<cfargument name="Translator" type="Any" required="yes" />
		<cfargument name="getSafeFormName" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="yes" />
		
		<cfset variables.ValType = lcase(ListLast(getMetadata(this).name,"_"))/>
		<cfset variables.Translator = arguments.Translator />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		<cfset variables.getSafeFormName = arguments.getSafeFormName />
		<cfset variables.DefaultFailureMessage = "" />
		
		<cfreturn this />
	</cffunction>
	
	<!--- Public Functions --->
	
	<cffunction name="generateAddMethod" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="theMethod" type="any" required="yes" hint="The JS method to use for the validator." />
		<cfargument name="defaultMessage" type="any" required="no" default="" hint="A default message to display on failure." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var failureMessage = "" />
		
		<cfif Len(arguments.defaultMessage) GT 0>
			<cfset failureMessage = getDefaultFailureMessage(arguments.defaultMessage,arguments.locale)/>
		</cfif>
		
		<cfoutput>
		<cfsavecontent variable="theScript">
		jQuery.validator.addMethod("#getValType()#", #arguments.theMethod#, jQuery.format("#failureMessage#"));
		</cfsavecontent>
		</cfoutput>

		<cfreturn trim(theScript)/>

	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfset var safeSelectorScript = getSafeSelectorScript(argumentCollection=arguments) />
		<cfset var theScript = "if (#safeSelectorScript#.length) { #generateRuleScript(validation=arguments.validation,selector=safeSelectorScript,locale=arguments.locale)#}" />
		<cfreturn theScript />
	</cffunction>
	
	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="selector" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		
		<cfreturn generateAddRule(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="generateAddRule" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="selector" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfset var theScript = "" />
		
		<cfset theScript = "#arguments.selector#.rules('add',#generateRuleStruct(argumentCollection=arguments)#);" />
		
		<cfreturn theScript/>
	</cffunction>
	
	<cffunction name="generateValidationJSON" returntype="any" access="public" output="false" hint="I generate the JS JSON object required to implement the validations.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfset var theJSON = "" />
		<cfset arguments.selector = getSafeSelectorScript(argumentCollection=arguments) />
		<cfset theJSON = '{"#validation.getClientFieldName()#" : #generateRuleStruct(argumentCollection=arguments)#}' />
		<cfreturn theJSON />
	</cffunction>
	
	<cffunction name="generateConditionJSON" returntype="any" access="public" output="false" hint="I generate the JSON object required to implement conditions for validations.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfscript>
			var theConditions = {};
			//theCondition = '{"conditions": #getConditionDef(argumentCollection=arguments)#}';
			//theConditions["#arguments.formName#"]["#arguments.validation.getClientFieldName()#"]["#arguments.validation.getValType()#"] = deserializeJSON(conditionDef);
		</cfscript>
		<cfreturn  serializeJSON(getConditionDef(argumentCollection=arguments)) />
	</cffunction>

	<cffunction name="generateRuleStruct" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="selector" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		
		<!--- Determine what failureMessage to use for this Validation --->
		<cfset var failureMessage = determineFailureMessage(argumentCollection=arguments) />
		<cfset var theStruct = "" />
		
		<cfset var conditionDef = getConditionDef(argumentCollection=arguments)>
		<cfset var ruleDef = getRuleDef(arguments.validation) />
		<cfset var messageDef = getMessageDef(failureMessage,getValType(),arguments.locale)/>
		
		<cfif len(ruleDef) GT 0>
			<cfset theStruct = "{#ruleDef##messageDef##conditionDef#}" />
		</cfif>
		
		<cfreturn theStruct/>
		
	</cffunction>
	
	<cffunction name="getRuleDef" returntype="any" access="public" output="false" hint="I return just the rule definition which is required for the generateAddRule method.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var parameterDef = getParameterDef(arguments.validation)/>
		<cfset var ruleDef = '"#getValType()#": #parameterDef#' />
		<cfreturn ruleDef />
	</cffunction>	
	
	<cffunction name="getParameterDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate paramters to the validator method.">
		<cfargument name="validation" type="any"/>

		<cfset var parameterDef = ""/>
		<cfset var conditionDef = ""/>
		
		<cfset var paramName = "" />
		<cfset var paramList = "" />
		<cfset var parameters = {} />

		<cfif arguments.validation.hasClientTest()>
			<cfset arguments.validation.addParameter("depends",arguments.validation.getConditionName())>
		</cfif>
		
		<cfset parameters = arguments.validation.getParameters()/>
		
		<cfif structCount(parameters) GT 0>
			<cfif structCount(parameters) EQ 1>
				<cfset paramName = structKeyArray(parameters) />
				<cfset paramName = paramName[1] />
				<cfset parameterDef = parameterDef & parameters[paramName] />
			<cfelse>
				<cfset parameterDef = serializeJSON(parameters)/>
			</cfif>
		</cfif>
		
		<cfif len(parameterDef) eq 0>
			<cfset parameterDef &= '"true"' />
			
		</cfif>
		
		<cfreturn parameterDef/>
		
	</cffunction>

	
	<cffunction name="getConditionDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate depends conditions to the validator method.">
		<cfargument name="validation" type="any"/>
		<cfset var condition = arguments.validation.getCondition() />
		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var conditionDef = "" />
		<cfif arguments.validation.hasClientTest()>
			<cfreturn  ',"conditions": {"#arguments.validation.getConditionName()#" : "#arguments.validation.getClientTest()#"}' />
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>
	 
	<cffunction name="getMessageDef" returntype="string" access="public" output="false" hint="I generate the JS script required to display the appropriate failure message.">
		<cfargument name="message" type="string" default="#getDefaultFailureMessage()#"/>
		<cfargument name="valType" type="string" default="#getValType()#"/>
		<cfargument name="locale" type="string" default=""/>
		
		<cfset var messageDef = ""/>
		<cfset var failureMessage = arguments.message/>		
		<cfif len(failureMessage) gt 0>
			<cfset failureMessage = translate(failureMessage,arguments.locale)/>
			<cfset messageDef = ',"messages":{"#arguments.valType#":"#failureMessage#"}'/>
		</cfif>
		<cfreturn messageDef/>
	</cffunction>

	<!--- Private Function --->	
	<cffunction name="getValType" returntype="string" access="private" output="false" hint="I generate the JS script required to implement a validation.">
		<cfreturn variables.ValType />
	</cffunction>

	<cffunction name="getSafeSelectorScript" returntype="string" access="private" output="false" hint="I generate the JS script required to select a property input element.">
		<cfargument name="validation" type="any"/>
		<cfargument name="formName" type="string" default=""/>
		<cfset var safeFormName = variables.getSafeFormName(arguments.formName)/>
		<cfset var safeFieldName = arguments.validation.getClientFieldName()/>
		<cfreturn "$("":input[name='#safeFieldName#']"",$form_#safeFormName#)" />
	</cffunction>	
	
	<cffunction name="determineFailureMessage" returntype="any" access="private" output="false" hint="I determin the actual failure message to be used.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />

		<!--- Lets first try getCustomFailureMessage on either the AbstractClientRuleScripter or the CRS implementation --->
		<cfset var failureMessage = getCustomFailureMessage(arguments.validation) />

		<!---  If we don't get anything there, lets go for getTheDefaultFailuremessage for this validation' --->
		<cfif len(failureMessage) eq 0>
			<cfset failureMessage = getDefaultFailureMessage(arguments.validation) />
		</cfif>
		
		<cfreturn failureMessage/>
	</cffunction>
	
	<cffunction name="getCustomFailureMessage" returntype="any" access="private" output="false" hint="I return the custom failure message from the validation object.">
		<cfargument name="validation" type="any" default=""/>
		<!--- If this validation a failureMessage from the metadata, then use that --->
		<cfif arguments.validation.hasFailureMessage()>
			<cfreturn arguments.validation.getFailureMessage() />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<!--- TODO: set DefaultFailureMessage property, and or override the getDefaultFailureMessage in a CRS to set custom messages --->
	<cffunction name="getDefaultFailureMessage" returntype="any" access="private" output="false" hint="I return the translated default failure message from the validation object.">
		<cfargument name="validation" type="any"/>
		<!--- 
			  If no DefaultFailureMessage proprerty is defined by the CRS then this should ultimately fall back on:
			  1) any failure messages determined by the custom CRS
			  2) the CRS generateInitScript's default failure message
			  3) any jquery.validate plugin default failure messages for base types
		--->
		<cfreturn variables.DefaultFailureMessage />
	</cffunction>

	<cffunction name="createDefaultFailureMessage" returntype="string" access="private" output="false" hint="I prepend the defaultFailureMessagePrefix to a message.">
		<cfargument name="FailureMessage" type="any" required="yes" hint="A Failure message to add to." />
		<cfreturn variables.defaultFailureMessagePrefix & arguments.FailureMessage />
	</cffunction>

	<cffunction name="translate" returntype="string" access="private" output="false" hint="I translate a message.">
		<cfargument name="message" type="string" default=""/>		
		<cfargument name="locale" type="string" default=""/>
		<cfreturn  variables.Translator.translate(arguments.message,arguments.locale) />
	</cffunction>

</cfcomponent>