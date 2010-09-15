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
<cfcomponent output="false" name="ClientRuleScripter_PastDate" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the past date validation.">

   <cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
        <cfargument name="defaultMessage" type="string" required="false" default="The date entered must be in the past.">
        <cfset var theCondition="function(value,element,options) { return true; }"/>
         
		 <!--- JAVASCRIPT VALIDATION METHOD --->
	      <cfsavecontent variable="theCondition">
	      function(value,element,options) {
	            var dBefore = new Date(); 
	            var dValue  = new Date(value); 
	            
	            if (options.before) {
	            	dBefore = new Date(options.before);
	            }
	            
	            return (dBefore > dValue);
	      }
	      </cfsavecontent>
    
       <cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
    </cffunction>
    
    <cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
        <cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
        <cfargument name="formName" type="Any" required="yes" />
        <cfargument name="defaultFailureMessagePrefix" type="Any" required="yes" />
        <cfargument name="customMessage" type="Any" required="no" default="" />
        <cfargument name="locale" type="Any" required="no" default="" />

        <cfset var theScript = "" />
        <cfset var safeFormName = variables.getSafeFormName(arguments.formName) />
        <cfset var fieldName = safeFormName & arguments.validation.getClientFieldName() />
        <cfset var valType = this.getValType() />       
        <cfset var params = arguments.validation.getParameters()/>
        <cfset var fieldSelector = "$form_#safeFormName#.find("":input[name='#arguments.validation.getClientFieldName()#']"")" />
        
		<cfset var options = true/>
		<cfset var messageScript = "" />
        
		<cfif Len(arguments.customMessage) eq 0>
            <cfset arguments.customMessage = createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must be a date in the past.") />
        </cfif>
        
		<cfif arguments.validation.hasParameter("before")>
			<cfset options = {before=arguments.validation.getParameterValue("before")} />
			<cfset arguments.customMessage = arguments.customMessage & " The date entered must come before #arguments.validation.getParameterValue('before')#"/>
		</cfif>
		
		<cfset messageScript = variables.Translator.translate(arguments.customMessage,arguments.locale) />
		
		
         <cfoutput>
         <cfsavecontent variable="theScript">
             #fieldSelector#.rules("add", {
                  #valType# : #serializeJSON(options)#,
                  messages: {"#valType#": "#messageScript#"}
             });
         </cfsavecontent>
         </cfoutput>
            
        <cfreturn theScript/>
    </cffunction>

</cfcomponent>