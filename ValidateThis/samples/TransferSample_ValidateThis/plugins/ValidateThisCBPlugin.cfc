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
<cfcomponent name="ValidateThisCBPlugin" hint="I am a plugin that allows ValidateThis to be accessed easily from within Coldbox." extends="coldbox.system.plugin" output="false" cache="true" cachetimeout="0">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfset var key = 0 />
		<cfset var ValidateThisConfig = StructNew() />
		<cfset super.Init(arguments.controller) />
		<cfset setpluginName("ValidateThis Plugin") />
		<cfset setpluginVersion("0.2") />
		<cfset setpluginDescription("I allow ValidateThis to be accessed easily from within Coldbox.") />
		<!--- Create a ValidateThisConfig struct from data in the Coldbox settings --->
		<cfloop list="VT_TranslatorPath,VT_LocaleLoaderPath,VT_BOValidatorPath,VT_DefaultJSLib,VT_JSRoot,VT_defaultFormName,VT_definitionPath,VT_localeMap,VT_defaultLocale" index="key">
			<cfif settingExists(key)>
				<cfset ValidateThisConfig[Replace(key,"VT_","")] = getSetting(key) />
			</cfif>
		</cfloop>
		<!--- If no definitionPath was defined, use the ModelsPath and (optionally) the ModelsExternalLocationPath from the ColdBox config --->
		<cfif NOT StructKeyExists(ValidateThisConfig,"definitionPath")>
			<cfset ValidateThisConfig.definitionPath = getSetting("ModelsPath") & "/" />
			<cfif Len(getSetting("ModelsExternalLocationPath"))>
				<cfset ValidateThisConfig.definitionPath = ListAppend(ValidateThisConfig.definitionPath, getSetting("ModelsExternalLocationPath")) />
			</cfif>
		</cfif>
		<cfset variables.ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig) />
		<cfreturn this>
	</cffunction>

	<!--- Public methods - These are explicitly created to provide a concrete API for the Plugin --->

	<cffunction name="validate" access="public" output="false" returntype="any" hint="I am used to perform server-side validations on an object">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="Context" type="any" required="false" />
		<cfargument name="Result" type="any" required="false" />

		<cfreturn variables.ValidateThis.validate(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="setupValidationSI" access="public" output="false" returntype="void" hint="Creates the default form setup for jQuery validation using the scriptInclude plugin.">
		<!--- Based on a Plugin created by Craig McDonald --->
		<!--- Note: This has not been tested --->
		<cfargument name="objectList" type="any" required="true" hint="One or more objects to validate. As a list" />
		<cfargument name="context" type="any" required="false" default="" hint="The context of the form to validate" />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfargument name="formName" type="Any" required="false" default="" />
		<cfargument name="loadMainLibrary" type="Any" required="false" default="false" />

		<cfset var scriptInclude = getMyPlugin("scriptInclude") />
		<cfset var object = 0 />
		<cfif arguments.loadMainLibrary>
			<cfset scriptInclude.addResource(file='jquery-1.3.2.min',type='JS',path='') />
		</cfif>
		<cfset scriptInclude.addResource(file='jquery.field.min',type='JS',path='') />
		<cfset scriptInclude.addResource(file='jquery.validate.min',type='JS',path='') />
		<cfset scriptInclude.addScript(script=getInitializationScript(JSLib="jQuery",JSIncludes=false,locale=arguments.locale)) />
		<cfloop index="object" list="#arguments.objectList#">		
			<cfset scriptInclude.addScript(script=getValidationScript(JSLib="jQuery",objectType=object,Context=arguments.context,formName=arguments.formName,locale=arguments.locale)) />
		</cfloop>
	
	</cffunction>

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" hint="I generate client-side validations scripts for an object">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="Context" type="any" required="false" />
		<cfargument name="formName" type="any" required="false" />
		<cfargument name="JSLib" type="any" required="false" />
		<cfargument name="locale" type="Any" required="false" />

		<cfreturn variables.ValidateThis.getValidationScript(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate JS statements required to setup client-side validations for VT.">
		<cfargument name="JSLib" type="any" required="false" />
		<cfargument name="JSIncludes" type="Any" required="no" default="true" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfreturn variables.ValidateThis.getInitializationScript(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getRequiredProperties" access="public" output="false" returntype="any" hint="I return a structure containing the name of all of the required properties for the given context.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="Context" type="any" required="false" />

		<cfreturn variables.ValidateThis.getRequiredProperties(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getRequiredFields" access="public" output="false" returntype="any" hint="I return a structure containing the name of all of the required fields for the given context.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="Context" type="any" required="false" />

		<cfreturn variables.ValidateThis.getRequiredFields(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getAllContexts" access="public" output="false" returntype="any" hint="I return a Struct containing all of the rules defined for the object.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />

		<cfreturn variables.ValidateThis.getAllContexts(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="addRule" returnType="void" access="public" output="false" hint="I am used to add a rule via CFML code">
		<cfargument name="propertyName" type="any" required="true" />
		<cfargument name="valType" type="any" required="true" />
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="clientFieldName" type="any" required="false" />
		<cfargument name="propertyDesc" type="any" required="false" />
		<cfargument name="condition" type="Struct" required="false" />
		<cfargument name="parameters" type="Struct" required="false" />
		<cfargument name="contexts" type="any" required="false" />
		<cfargument name="failureMessage" type="any" required="false" />
		<cfargument name="formName" type="any" required="false" />

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

</cfcomponent>
	

