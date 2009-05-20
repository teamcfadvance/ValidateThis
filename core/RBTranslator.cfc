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
<cfcomponent output="false" name="RBTranslator" extends="BaseTranslator" hint="I use Resource Bundles to translate text.">

	<cffunction name="translate" returnType="any" access="public" output="false" hint="I translate text">
		<cfargument name="translateThis" type="Any" required="true" />
		<cfargument name="locale" type="Any" required="false" default="" />
		
		<cfif NOT StructKeyExists(variables.instance.locales,arguments.locale)>
			<cfthrow type="validatethis.core.RBTranslator.LocaleNotDefined"
				message="The locale requested, '#arguments.locale#', has not been defined in the localeMap in the ValidateThisConfig." />
		<cfelseif NOT StructKeyExists(variables.instance.locales[arguments.locale],arguments.translateThis)>
			<cfthrow type="validatethis.core.RBTranslator.KeyNotDefined"
				message="The key requested, '#arguments.translateThis#', has not been defined in the locale '#arguments.locale#'." />
		</cfif>
		<cfreturn variables.instance.locales[arguments.locale][arguments.translateThis] />
	</cffunction>

	<cffunction name="loadLocales" returnType="void" access="public" output="false" hint="I load the resource bundle info into the cache">
		<cfargument name="localeMap" type="Any" required="true" />

		<cfset var locale = 0 />
		
		<cfloop collection="#arguments.localeMap#" item="locale">
			<cfset variables.instance.locales[locale] = variables.TransientFactory.newResourceBundle().getResourceBundle(ExpandPath(arguments.localeMap[locale]),locale) />
		</cfloop>		

	</cffunction>

</cfcomponent>
	

