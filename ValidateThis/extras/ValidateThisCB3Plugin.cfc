<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent name="ValidateThisCBPlugin" 
	hint="I am a plugin that allows ValidateThis to be accessed easily from within Coldbox 3.0." 
	output="false" 
	singleton="true">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var key = 0 />
		<cfset var setting = 0 />
		<cfset var ValidateThisConfig = StructNew() />
		
		<cfset setpluginName("ValidateThis Plugin") />
		<cfset setpluginVersion("0.3") />
		<cfset setpluginDescription("I allow ValidateThis to be accessed easily from within Coldbox 3.0.") />
		<cfset setPluginAuthor("Bob Silverberg") />
		<cfset setPluginAuthorURL("http://www.silverwareconsulting.com/") />
		
		<!--- 
		check for ValidateThis setting defined in Coldbox.cfc or Coldbox.xml.cfm 
		
		Coldbox.cfc settings should be in the format:
			settings = {
				ValidateThisConfig = {JSRoot='/js/',defaultFormName='formToValidate'}
			}
		
		Coldbox.xml.cfm settings should be in the format:
			<Setting name="ValidateThisConfig" value="{JSRoot:'/js/',defaultFormName:'formToValidate'}" />
		--->
		<cfif settingExists("ValidateThisConfig")>
			<!--- settings found so use them to configure ValidateThis --->
			<cfset ValidateThisConfig = getSetting("ValidateThisConfig") />
		</cfif>

		
		<!--- Create a ValidateThisConfig struct from data in the Coldbox settings --->
		<cfloop list="VT_TranslatorPath,VT_LocaleLoaderPath,VT_BOValidatorPath,VT_DefaultJSLib,VT_JSRoot,VT_defaultFormName,VT_definitionPath,VT_localeMap,VT_defaultLocale,VT_abstractGetterMethod,VT_ExtraRuleValidatorComponentPaths,VT_ExtraClientScriptWriterComponentPaths,VT_ExtraFileReaderComponentPaths,VT_externalFileTypes,VT_injectResultIntoBO,VT_JSIncludes" index="key">
		
			<cfif settingExists(key)>
				<cfset setting = Replace(key,"VT_","")>
				<!--- throw an error if the setting is already defined --->		
				<cfif settingExists(key) AND StructKeyExists(ValidateThisConfig, setting)>
					<cfthrow type="ValidateThisCBPlugin.init.duplicateSetting"
						message="Duplicate setting in ColdBox.xml.cfm" 
						detail="The setting '#setting#' is already defined in the 'ValidateThisConfig' setting" />
				<cfelse>
					<cfset ValidateThisConfig[setting] = getSetting(key) />
				</cfif>
			</cfif>
		</cfloop>
		<!--- If no definitionPath was defined, use the ModelsPath and (optionally) the ModelsExternalLocation from the ColdBox config --->
		<cfif NOT StructKeyExists(ValidateThisConfig,"definitionPath")>
			<cfset ValidateThisConfig.definitionPath = getSetting("ModelsPath") & "/" />
			<cfif settingExists("ModelsExternalLocation") AND Len(getSetting("ModelsExternalLocation"))>
				<cfset ValidateThisConfig.definitionPath = ListAppend(ValidateThisConfig.definitionPath, getSetting("ModelsExternalLocation")) />
			</cfif>
		</cfif>
		
		<!--- check if ColdBox is using a resource bundle --->
		<cfif settingExists("defaultLocale") AND getSetting("defaultLocale") neq "">
			<!--- a custom translator hasn't been set so use ValidateThis.extras.ColdBoxRBTranslator --->
			<cfif NOT StructKeyExists(ValidateThisConfig,"translatorPath")>
				<cfset ValidateThisConfig.translatorPath = "ValidateThis.extras.ColdBoxRBTranslator" />
			</cfif>
		</cfif>
		
		<cfset variables.ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig) />
		<cfset log.debug("ValidateThis loaded")>
		
		<cfif settingExists("defaultLocale") AND getSetting("defaultLocale") neq "">
			<!--- inject the ColdBox resource bundle into the translator, this does assume that if a custom translator has been defined it will have a setResourceBundle() method --->
			<cftry>
				<cfset variables.ValidateThis.getBean("Translator").setResourceBundle(getPlugin("ResourceBundle"))>
				<cfcatch>
					<cfset log.debug("ValidateThisCB3Plugin error: setResourceBundle method not found")>
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn this>
	</cffunction>

	<!--- Public methods - These are explicitly created to provide a concrete API for the Plugin --->

	<cffunction name="validate" access="public" output="false" returntype="any" hint="I am used to perform server-side validations on an object">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="objectType" type="string" required="false" />
		<cfargument name="Context" type="string" required="false" />
		<cfargument name="Result" type="any" required="false" />

		<cfreturn variables.ValidateThis.validate(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="setupValidationSI" access="public" output="false" returntype="void" hint="Creates the default form setup for jQuery validation using the HTMLHelper plugin.">
		<cfargument name="objectList" type="string" required="true" hint="One or more objects to validate. As a list" />
		<cfargument name="context" type="any" required="false" default="" hint="The context of the form to validate" />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfargument name="formName" type="Any" required="false" default="" />
		<cfargument name="loadMainLibrary" type="Any" required="false" default="false" />

		<cfset var HTMLHelper = getPlugin('HTMLHelper') />
		<cfset var object = 0 />
		<cfif arguments.loadMainLibrary>
			<cfset HTMLHelper.addAsset(file='jquery-1.4.2.min.js') />
		</cfif>
		<cfset HTMLHelper.addAsset('jquery.field.min.js') />
		<cfset HTMLHelper.addAsset('jquery.validate.pack.js') />
		
		<cfhtmlhead text="#getInitializationScript(JSLib="jQuery",JSIncludes=false,locale=arguments.locale)#">		
		
		<cfloop index="object" list="#arguments.objectList#">
			<cfhtmlhead text="#getValidationScript(JSLib="jQuery",objectType=object,Context=arguments.context,formName=arguments.formName,locale=arguments.locale)#">
		</cfloop>
	
	</cffunction>

	<cffunction name="getValidationScript" returntype="string" access="public" output="false" hint="I generate client-side validations scripts for an object">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="string" required="false" />
		<cfargument name="Context" type="string" required="false" />
		<cfargument name="formName" type="string" required="false" />
		<cfargument name="JSLib" type="string" required="false" />
		<cfargument name="locale" type="string" required="false" />

		<cfreturn variables.ValidateThis.getValidationScript(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate JS statements required to setup client-side validations for VT.">
		<cfargument name="JSLib" type="string" required="false" />
		<cfargument name="JSIncludes" type="boolean" required="false" />
		<cfargument name="locale" type="string" required="false" />

		<cfreturn variables.ValidateThis.getInitializationScript(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getRequiredProperties" access="public" output="false" returntype="any" hint="I return a structure containing the name of all of the required properties for the given context.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="string" required="false" />
		<cfargument name="Context" type="string" required="false" />

		<cfreturn variables.ValidateThis.getRequiredProperties(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getRequiredFields" access="public" output="false" returntype="any" hint="I return a structure containing the name of all of the required fields for the given context.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="string" required="false" />
		<cfargument name="Context" type="string" required="false" />

		<cfreturn variables.ValidateThis.getRequiredFields(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getAllContexts" access="public" output="false" returntype="any" hint="I return a Struct containing all of the rules defined for the object.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="string" required="false" />

		<cfreturn variables.ValidateThis.getAllContexts(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="newResult" access="public" output="false" returntype="any" hint="I return a new, empty Result object.">
		<cfreturn variables.ValidateThis.newResult() />
	</cffunction>

	<cffunction name="addRule" returnType="void" access="public" output="false" hint="I am used to add a rule via CFML code">
		<cfargument name="propertyName" type="string" required="true" />
		<cfargument name="valType" type="string" required="true" />
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="string" required="false" />
		<cfargument name="clientFieldName" type="string" required="false" />
		<cfargument name="propertyDesc" type="string" required="false" />
		<cfargument name="condition" type="Struct" required="false" />
		<cfargument name="parameters" type="Struct" required="false" />
		<cfargument name="contexts" type="string" required="false" />
		<cfargument name="failureMessage" type="string" required="false" />
		<cfargument name="formName" type="string" required="false" />

		<cfreturn variables.ValidateThis.addRule(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="I am used to pass all method calls to the composed ValidateThis object.">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var returnValue = "" />

		<cfinvoke component="#variables.ValidateThis#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />
		<cfif NOT IsDefined("returnValue")>
			<cfset returnValue = "" />
		</cfif>

		<cfreturn returnValue />
		
	</cffunction>

	<cffunction name="loadValidators" returnType="void" access="public" output="false" hint="I am used to add a rule via CFML code">
		<cfargument name="objectList" type="string" required="true" />
		
		<cfreturn variables.ValidateThis.loadValidators(argumentCollection=arguments) />
		
	</cffunction>
	
</cfcomponent>
	

