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
<cfcomponent output="false" name="ClientRuleScripter_equalTo" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the equalTo validation.">

	<cffunction name="getValType" returntype="any" access="public" output="false" hint="I override the val type because jQuery requires the valtype to be 'equalTo' with that case.">
		<cfreturn "equalTo" />
	</cffunction>	

	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var params = arguments.validation.getParameters() />
		<cfreturn """:input[name='#params.ComparePropertyName#']""" />
	</cffunction>

	<cffunction name="getDefaultFailureMessage" returntype="any" access="private" output="false">
		<cfargument name="validation" type="any"/>
		<cfset var params = arguments.validation.getParameters() />
		<cfreturn createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must be the same as #variables.defaultFailureMessagePrefix##params.ComparePropertyDesc#.") />
	</cffunction>

</cfcomponent>
