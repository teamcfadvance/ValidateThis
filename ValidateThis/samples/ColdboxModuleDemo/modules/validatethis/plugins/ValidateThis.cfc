<!---
	
	Copyright 2009, Bob Silverberg & John Whish
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent name="ValidateThisCBPlugin" 
	hint="I am a plugin for dealing with ValidateThis stuff easily from within Coldbox 3.0." 
	output="false"
	extends="coldbox.system.plugins.HTMLHelper"
	accessors="true"
	singleton="true">

	<cfproperty name="ValidateThis" inject="ocm:ValidateThis"/>

	<!--- Virtual Method API For The Cached ValidateThis Facade --->
	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="I am used to pass all method calls to the composed ValidateThis object.">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />
		<cfset var returnValue = "" />
		<cfinvoke component="#getValidateThis()#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />
		<cfif NOT IsDefined("returnValue")>
			<cfset returnValue = "" />
		</cfif>
		<cfreturn returnValue />
	</cffunction>

	<!--- Property Accessors --->
	<cffunction name="getValidateThis" access="private" returntype="any" output="false">
		<cfreturn variables.ValidateThis/>
	</cffunction>
	<cffunction name="setValidateThis" access="private" returntype="any" output="false">
		<cfargument name="ValidateThis" type="any" required="true">
		<cfreturn variables.ValidateThis = arguments.ValidateThis/>
	</cffunction>
	
</cfcomponent>
	

