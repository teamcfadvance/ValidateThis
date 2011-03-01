<!---
	
	Copyright 2008, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ClientRuleScripter_DateRange" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the past date validation.">

   <cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
        <cfargument name="defaultMessage" type="string" required="false" default="The date entered must be in the range specified.">
        <cfset var theScript="">
        <cfset var theCondition="function(value,element,options) { return true; }"/>

          <!--- JAVASCRIPT VALIDATION METHOD --->
	      <cfsavecontent variable="theCondition">
	      function(value,element,options) {
	            var dValue  = new Date(value); 
	            var isValid = true;
	            var fromDate = new Date();
                var toDate = new Date();
	            
	            if (options.from){
	            	var fromDate = 	new Date(options.from);
	            } 
	            if (options.until){
	            	var untilDate = new Date(options.until);
	            } 
	            
	            if (toDate == fromDate){
	            	isValid = true;
	            } else {	            
		            isValid = ((fromDate < dValue) & (dValue < untilDate)) ? true : false;
		        }
				
				return isValid;
	      }
	      </cfsavecontent>
    
        <cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
    </cffunction>

	<cffunction name="getDefaultFailureMessage" returntype="any" access="private" output="false">
		<cfargument name="validation" type="any"/>

        <cfset var params = arguments.validation.getParameters()/>
		<cfreturn createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must contain a date between #params['from']# and #params['until']#.") />
	</cffunction>

</cfcomponent>

