<!--- 
DoesNotContainOtherProperties:
	ServerRuleValidator Implmenetation By Marc Esher:
	ClientRuleScripter Implementation By Adam Drew

Definition Usage Example:

<rule type="DoesNotContainOtherProperties" failuremessage="Password may not contain your first or last name." >
	<param name="propertyNames" value="firstName,LastName"/>
</rule>
<rule type="DoesNotContainOtherProperties" failuremessage="Password may not contain your username.">
	<param name="propertyNames" value="username" />
</rule>
<rule type="DoesNotContainOtherProperties" failuremessage="Password may not contain your email address." >
	<param name="propertyNames" value="emailAddress"/>
</rule>
<rule type="DoesNotContainOtherProperties" failuremessage="This better be ignored!" >
	<param name="propertyNames" value"="thisPropertyDoesNotExist"/>
</rule>

--->

<cfcomponent name="ClientRuleScripter_DoesNotContainOtherValues" extends="AbstractClientRuleScripter" hint="Fails if the validated property contains the value of another property">
	
	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The value cannot not contain the value of another property.">
		<cfset var theScript="">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(value,element,options) {
			var isValid = true;
			$(options).each(function(){		
				var propertyName = this;			
				var propertyValue = $(':input[name='+this+']').getValue();
				if (propertyValue.length){
					// if this is a mutilple select list, split the value into an array for iteration
					if (propertyValue.search(",")){
						propertyValue = propertyValue.split( "," )
					};
					// for each property value in the array to check
					$(propertyValue).each(function(){
						var test = value.toString().toLowerCase().search(this.toString().toLowerCase()) == -1;
						if (!test){ // Only worrie about failures here so we return true if none of the other values fail.
							isValid = false;
						}
					});
				}
				return isValid;
			});
			return isValid;
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
		<cfset var valType = this.getValType() />		
		<cfset var params = arguments.validation.getParameters()/>
		<cfset var fieldSelector = "$form_#safeFormName#.find("":input[name='#arguments.validation.getClientFieldName()#']"")" />
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<cfset var messageScript = "" />
		
		<cfif Len(arguments.customMessage) eq 0>
			<cfset arguments.customMessage = "#arguments.validation.getPropertyDesc()# must not contain the values of properties named: #params.propertyNames#."/>
		</cfif>
		<cfset messageScript = variables.Translator.translate(arguments.customMessage,arguments.locale)/>

		<cfif StructKeyExists(params,"propertyNames")>
			<cfoutput>
				<cfsavecontent variable="theScript">
					#fieldSelector#.rules("add", {
						 #valType# : #serializeJSON(listToArray(trim(params.propertyNames)))#,
						 messages: {"#valType#": "#messageScript#"}
					});
			</cfsavecontent>
			</cfoutput>
			
		</cfif>
		<cfreturn theScript/>
	</cffunction>
</cfcomponent>