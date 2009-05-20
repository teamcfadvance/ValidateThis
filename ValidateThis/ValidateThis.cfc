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
<cfcomponent output="false" name="ValidateThis" hint="I accept a BO and use the framework to validate it.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidateThis">
		<cfargument name="ValidateThisConfig" type="any" required="false" default="#StructNew()#" />

		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<!--- Set default values for keys in ValidateThisConfig --->
		<cfparam name="variables.ValidateThisConfig.TranslatorPath" default="ValidateThis.core.BaseTranslator" />
		<cfparam name="variables.ValidateThisConfig.BOValidatorPath" default="BOValidator" />
		<cfparam name="variables.ValidateThisConfig.DefaultJSLib" default="jQuery" />
		<cfparam name="variables.ValidateThisConfig.JSRoot" default="js/" />
		<cfparam name="variables.ValidateThisConfig.defaultFormName" default="frmMain" />
		<cfparam name="variables.ValidateThisConfig.definitionPath" default="/model/" />
		<cfparam name="variables.ValidateThisConfig.localeMap" default="#StructNew()#" />
		<cfset variables.ValidationFactory = CreateObject("component","core.ValidationFactory").init(variables.ValidateThisConfig) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="false" default="" />

		<cfreturn variables.ValidationFactory.getValidator(arguments.objectType,arguments.definitionPath) />
		
	</cffunction>
	
	<cffunction name="validate" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="Result" type="any" required="false" default="" />
		<cfargument name="locale" type="any" required="false" default="" />

		<cfset var BOValidator = getValidator(arguments.objectType,"") />
		<!--- Inject testCondition if needed --->
		<cfif NOT StructKeyExists(arguments.theObject,"testCondition")>
			<cfset arguments.theObject["testCondition"] = this["testCondition"] />
		</cfif>
		<cfset arguments.Result = BOValidator.validate(arguments.theObject,arguments.Context,arguments.Result,arguments.locale) />
		
		<cfreturn arguments.Result />

	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="This is used to help communicate with the BOValidator, which is accessed via the ValidationFactory when needed">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var local = {} />
		<cfset local.returnValue = "" />
		<cfset local.objectType = "" />
		
		<cfif StructKeyExists(arguments.missingMethodArguments,"objectType")>
			<cfset local.objectType = arguments.missingMethodArguments.objectType />
		<cfelseif StructKeyExists(arguments.missingMethodArguments,"theObject") AND StructKeyExists(arguments.missingMethodArguments.theObject,"getobjectType")>
			<cfinvoke component="#arguments.missingMethodArguments.theObject#" method="getobjectType" returnvariable="local.objectType" />
		</cfif>
		<cfif Len(local.objectType)>
			<cfset local.BOValidator = getValidator(local.objectType,"") />
			<cfinvoke component="#local.BOValidator#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="local.returnValue" />
			<cfif NOT StructKeyExists(local,"returnValue")>
				<cfset local.returnValue = "" />
			</cfif>
		</cfif>
		<cfreturn local.returnValue />
		
	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn variables.ValidationFactory.newResult() />
		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I am used to aid Unit Testing">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfreturn variables.ValidationFactory.getBean(arguments.BeanName) />
	
	</cffunction>
	
</cfcomponent>
	

