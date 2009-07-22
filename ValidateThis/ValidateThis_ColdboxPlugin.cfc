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
<cfcomponent name="ValidateThis_ColdboxPlugin" hint="I am a plugin that allows ValidateThis to be accessed easily from within Coldbox." extends="coldbox.system.plugin" output="false" cache="true" cachetimeout="0">

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
		<cfset variables.ValidateThis = CreateObject("component","ValidateThis").init(variables.ValidateThisConfig) />
		<cfreturn this>
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
	

