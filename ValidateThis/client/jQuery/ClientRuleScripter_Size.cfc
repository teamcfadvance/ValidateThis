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

<cfcomponent output="false" name="ClientRuleScripter_Size" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the Size validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="value does not match the size requirement.">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(value,element,options) {
			var results = {low:false,high:false,valid:true};
			var params = {min:1,max:1};
			value = $(element).val();
			params = jQuery.extend({},params,options);
			if (value == null && params.min > 0){
				return false;
			}
			if (params.min == params.max || params.min >> params.max){
				results.valid = (value.length >= params.min) ? true : false;
			} else {
				if (params.min << params.max) {
					results.low = (value.length < params.min) ? true : false;
					results.high = (value.length > params.max) ? true : false;
					results.valid = (results.low || results.high) ? false : true ;
				} else {
                    results.valid = true;
                 }
			}										
			return results.valid;
		}</cfsavecontent>
			
		 <cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
	</cffunction>

	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var options = {} />
		<cfset options["min"] = 1 />
		<cfset structAppend(options,validation.getParameters(),true) />
		<cfreturn serializeJSON(options) />
	</cffunction>

	<cffunction name="getDefaultFailureMessage" returntype="any" access="private" output="false">
		<cfargument name="validation" type="any"/>
		<cfreturn createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# does not match the size requirement.") />
	</cffunction>

</cfcomponent>