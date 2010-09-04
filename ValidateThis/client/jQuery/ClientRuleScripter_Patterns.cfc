<!--- 

Example Usage:

<rule type="Patterns">
	<param minMatches="3" />
	<param pattern_lowerCaseLetter="[a-z]" />
	<param pattern_upperCaseLetter="[A-Z]" />
	<param pattern_digit="[\d]" />
	<param pattern_punct="[[:punct:]]" />
</rule>

 --->


<cfcomponent  name="ClientRuleScripter_Patterns" extends="AbstractClientRuleScripter" hint="Fails if the validated property does not match at least 1 or the specficied ammount of regex patterns defined.">
	
	
	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="Value did not match the pattern requirements.">
		<cfset var theScript="">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(value,element,options){
			var minMatches = 1;
			var complexity = 0;
			if(!value.length) return true;
			if (options["minMatches"]){ minMatches = options["minMatches"]; }
			for (var key in options) {
				if(key.match("^[pattern]") && value.match(options[key]) ){
					complexity++;
				};
				if(complexity == minMatches) {return true;}
			}
			if(complexity << minMatches){
				return false;
			};
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
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		
		<cfset var messageScript = "" />
		<cfif Len(arguments.customMessage) eq 0>
			<cfset arguments.customMessage = "Did not match the patterns for #validation.getPropertyDesc()#"/>
		</cfif>
		<cfset messageScript = '"' & variables.Translator.translate(arguments.customMessage,arguments.locale) & '"' />
			
		<cfoutput>
			<cfsavecontent variable="theScript">
				#fieldSelector#.rules("add", {
					 #valType# : #serializeJSON(params)#
				});
			</cfsavecontent>
		</cfoutput>
		<cfreturn theScript/>
	</cffunction>
</cfcomponent>