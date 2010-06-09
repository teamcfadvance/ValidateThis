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
<cfcomponent output="false" name="ValidationFactory" hint="I create BO Validators to inject into Business Objects.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidationFactory">
		<cfargument name="ValidateThisConfig" type="any" required="true" />

		<cfset variables.Beans = StructNew() />
		<cfset variables.Validators = StructNew() />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfset loadBeans() />
				
		<cfreturn this />
	</cffunction>

	<cffunction name="loadBeans" access="private" output="false" returntype="void" hint="I load the required singletons">
	
		<cfset variables.Beans.ValidationFactory = this />
		<cfset variables.Beans.Version = CreateObject("component","ValidateThis.core.Version").init() />
		<cfset variables.Beans.ObjectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init(variables.ValidateThisConfig.abstractGetterMethod) />
		<cfset variables.Beans.ResourceBundle = createObject("component","ValidateThis.util.ResourceBundle").init() />
		<cfset variables.Beans.LocaleLoader = CreateObject("component",variables.ValidateThisConfig.LocaleLoaderPath).init(variables.Beans.ResourceBundle) />
		<cfset variables.Beans.Translator = CreateObject("component",variables.ValidateThisConfig.TranslatorPath).init(variables.Beans.LocaleLoader,variables.ValidateThisConfig.localeMap,variables.ValidateThisConfig.defaultLocale) />
		<cfset variables.Beans.TransientFactory = CreateObject("component","ValidateThis.util.TransientFactoryNoCS").init(variables.Beans.Translator,variables.ValidateThisConfig.ResultPath) />
		<cfset variables.Beans.FileSystem = CreateObject("component","ValidateThis.util.FileSystem").init(variables.Beans.TransientFactory) />
		<cfset variables.Beans.XMLFileReader = CreateObject("component","ValidateThis.core.XMLFileReader").init(variables.Beans.FileSystem,variables.ValidateThisConfig) />
		<cfset variables.Beans.ServerValidator = CreateObject("component","ValidateThis.server.ServerValidator").init(variables.Beans.FileSystem,variables.Beans.TransientFactory,variables.Beans.ObjectChecker,variables.ValidateThisConfig.ExtraRuleValidatorComponentPaths) />
		<cfset variables.Beans.ClientValidator = CreateObject("component","ValidateThis.client.ClientValidator").init(variables.Beans.FileSystem,variables.ValidateThisConfig,variables.Beans.Translator) />
		<cfset variables.Beans.CommonScriptGenerator = CreateObject("component","ValidateThis.client.CommonScriptGenerator").init(variables.Beans.ClientValidator) />
		
	</cffunction>
	
	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I return a singleton">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfif StructKeyExists(variables.Beans,arguments.BeanName)>
			<cfreturn variables.Beans[arguments.BeanName] />
		<cfelse>
			<cfthrow type="ValidateThis.core.ValidationFactory.BeanNotFound" detail="No bean called #arguments.BeanName# was found.">
		</cfif>
	
	</cffunction>
	
	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="false" default="" />

		<cfif NOT StructKeyExists(variables.Validators,arguments.objectType)>
			<cfset variables.Validators[arguments.objectType] = createValidator(arguments.objectType,arguments.definitionPath) />
		</cfif>
		<cfreturn variables.Validators[arguments.objectType] />
		
	</cffunction>
	
	<cffunction name="createValidator" returntype="any" access="private" output="false">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />
		
		<cfreturn CreateObject("component",variables.ValidateThisConfig.BOValidatorPath).init(arguments.objectType,getBean("FileSystem"),getBean("XMLFileReader"),getBean("ServerValidator"),getBean("ClientValidator"),getBean("TransientFactory"),variables.ValidateThisConfig,arguments.definitionPath,getBean("CommonScriptGenerator"),getBean("Version")) />
		
	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn getBean("TransientFactory").newResult() />
		
	</cffunction>

</cfcomponent>
	

