f<!---
	
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
		<cfset setpluginVersion("1.0") />
		<cfset setpluginDescription("I allow ValidateThis to be accessed easily from within Coldbox.") />
		<!--- Create a ValidateThisConfig struct from data in the Coldbox settings --->
		<cfloop list="TranslatorPath,LocaleLoaderPath,BOValidatorPath,DefaultJSLib,JSRoot,defaultFormName,definitionPath,localeMap,defaultLocale" index="key">
			<cfif settingExists(key)>
				<cfset ValidateThisConfig[key] = getSetting(key) />
			</cfif>
		</cfloop>
		<!--- If no definitionPath was defined, using the ModelsPath from the ColdBox config --->
		<cfif NOT StructKeyExists(ValidateThisConfig,"definitionPath")>
			<cfset ValidateThisConfig.definitionPath = getSetting("ModelsPath") & "/" />
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

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" hint="I generate client-side validations scripts for an object">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="Context" type="any" required="false" />
		<cfargument name="formName" type="any" required="false" />
		<cfargument name="JSLib" type="any" required="false" />
		<cfargument name="locale" type="Any" required="false" />

		<cfreturn variables.ValidateThis.getValidationScript(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate setup Javascript for client-side validations. I am optional.">
		<cfargument name="theObject" type="any" required="false" />
		<cfargument name="objectType" type="any" required="false" />
		<cfargument name="Context" type="any" required="false" />
		<cfargument name="formName" type="any" required="false" />
		<cfargument name="JSLib" type="any" required="false" />
		<cfargument name="locale" type="Any" required="false" />

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

		<cfset returnValue = "" />
		<cfinvoke component="#variables.ValidateThis#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />
		<cfif NOT IsDefined("returnValue")>
			<cfset returnValue = "" />
		</cfif>
		<cfreturn returnValue />
		
	</cffunction>

</cfcomponent>
	

