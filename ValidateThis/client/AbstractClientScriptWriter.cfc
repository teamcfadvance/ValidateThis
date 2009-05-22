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
<cfcomponent output="false" name="AbstractClientScriptWriter" hint="I am an abstract class responsible for generating script for a particular JS implementation (e.g., qForms, jQuery, etc.).">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ClientScriptWriter">
		<!--- TODO: remove getters and setters in favour of variables. --->
		<cfargument name="VTFileSystem" type="any" required="true" />
		<cfargument name="ValidateThisConfig" type="any" required="true" />
		<cfargument name="Translator" type="any" required="true" />
		<cfset setVTFileSystem(arguments.VTFileSystem) />
		<cfset setValidateThisConfig(arguments.ValidateThisConfig) />
		<cfset variables.Translator = arguments.Translator />
		<cfset variables.RuleScripters = {} />

		<cfset setRuleScripters() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />

		<cfthrow errorcode="validatethis.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateValidationScript method must be overriden in a concrete object." />

	</cffunction>

	<cffunction name="generateScriptHeader" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">
		<cfargument name="formName" type="any" required="yes" />

		<cfthrow errorcode="validatethis.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateScriptHeader method must be overriden in a concrete object." />

	</cffunction>
	
	<cffunction name="generateScriptFooter" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">

		<cfthrow errorcode="validatethis.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateScriptFooter method must be overriden in a concrete object." />

	</cffunction>
	
	<cffunction name="generateInitializationScript" returntype="any" access="public" output="false" hint="I load the JS script required to initialize the libraries into the <head> tag.">
		<cfargument name="formName" type="any" required="yes" />

		<cfthrow errorcode="validatethis.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateInitializationScript method must be overriden in a concrete object." />

	</cffunction>

	<cffunction name="getRuleScripters" access="public" output="false" returntype="any">
		<cfreturn variables.RuleScripters />
	</cffunction>
	<cffunction name="setRuleScripters" returntype="void" access="public" output="false">
		<cfset var theMeta = GetMetadata(this) />
		<cfset var thisName = ListLast(theMeta.Name,".") />
		<cfset var RSNames = getVTFileSystem().listFiles(GetDirectoryFromPath(theMeta.Path)) />
		<cfset var RS = 0 />
		<cfloop list="#RSNames#" index="RS">
			<cfif ListLast(RS,".") EQ "cfc" AND NOT ListFindNoCase("AbstractClientRuleScripter.cfc,#thisName#.cfc",RS)>
				<cfset variables.RuleScripters[ReplaceNoCase(ListLast(RS,"_"),".cfc","")] = CreateObject("component",ReplaceNoCase(theMeta.Name,thisName,ReplaceNoCase(RS,".cfc",""))).init(variables.Translator) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getVTFileSystem" access="public" output="false" returntype="any">
		<cfreturn variables.VTFileSystem />
	</cffunction>
	<cffunction name="setVTFileSystem" returntype="void" access="public" output="false">
		<cfargument name="VTFileSystem" type="any" required="true" />
		<cfset variables.VTFileSystem = arguments.VTFileSystem />
	</cffunction>

	<cffunction name="getValidateThisConfig" access="public" output="false" returntype="any">
		<cfreturn variables.ValidateThisConfig />
	</cffunction>
	<cffunction name="setValidateThisConfig" returntype="void" access="public" output="false">
		<cfargument name="ValidateThisConfig" type="any" required="true" />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
	</cffunction>

</cfcomponent>
	

