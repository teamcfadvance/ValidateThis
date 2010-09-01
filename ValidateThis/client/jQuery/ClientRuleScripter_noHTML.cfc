<!---
	
	Copyright 2010, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.

--->

<cfcomponent output="false" name="ClientRuleScripter_noHTML" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the noHTML validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="value cannot contain any HTML tags.">
		<cfset var theScript="">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		
		
		<cfsavecontent variable="theCondition">function(value,element,options) {
			var m = value.search("</?\\w+((\\s+\\w+(\\s*=\\s*(?:\\\".*?\\\"|'.*?'|[^'\\\">\\s]+))?)+\\s*|\\s*)/?>");
			if (m == -1) return true;
			else return false;
		}</cfsavecontent>
			
		<cfoutput>
		<cfsavecontent variable="theScript">
		jQuery.validator.addMethod("noHTML", #theCondition#, jQuery.format("#arguments.defaultMessage#"));
		</cfsavecontent>
		</cfoutput>
		
		<cfreturn theScript/>
	</cffunction>

	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="Any" required="yes" />
		<cfargument name="customMessage" type="Any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var safeFormName = variables.getSafeFormName(arguments.formName) />
		<cfset var fieldName = safeFormName & arguments.validation.ClientFieldName />
		<cfset var valType = arguments.validation.ValType />		
		<cfset var params = arguments.validation.Parameters/>
		<cfset var fieldSelector = "$form_#safeFormName#.find("":input[name='#arguments.validation.ClientFieldName#']"")" />
		<cfset var theCondition="function(value,element,options) { return true; }"/>

			<cfif len(arguments.customMessage) eq 0>
				<cfset arguments.customMessage = "#arguments.validation.propertyName# cannot contain HTML tags."/>
			</cfif>

			<cfoutput>
			<cfsavecontent variable="theScript">
			#fieldSelector#.rules("add", {
				#valType# : true,
				messages: {
					#valType#: "#arguments.customMessage#"
				} 
			});
			</cfsavecontent>
			</cfoutput>

		<cfreturn theScript/>
	</cffunction>

</cfcomponent>