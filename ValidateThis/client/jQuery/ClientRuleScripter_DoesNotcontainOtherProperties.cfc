<!--- 
DoesNotContainOtherProperties:
	ServerRuleValidator Implmenetation By Marc Esher:
	ClientRuleScripter Implementation By Adam Drew

Definition Usage Example:

<rule type="DoesNotContainOtherProperties" failuremessage="Password may not contain your first or last name." >
	<param propertyNames="firstName,LastName"/>
</rule>
<rule type="DoesNotContainOtherProperties" failuremessage="Password may not contain your username.">
	<param propertyNames="username" />
</rule>
<rule type="DoesNotContainOtherProperties" failuremessage="Password may not contain your email address." >
	<param propertyNames="emailAddress"/>
</rule>
<rule type="DoesNotContainOtherProperties" failuremessage="This better be ignored!" >
	<param propertyNames="thisPropertyDoesNotExist"/>
</rule>

See ServerRuleValidator_DoesNotContainOtherProperties.cfc for cf server implmenetation
--->

<cfcomponent extends="AbstractClientRuleScripter" hint="Fails if the validated property contains the exact value of another property">
	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="Any" required="yes" />
		<cfargument name="customMessage" type="Any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var safeFormName = variables.getSafeFormName(arguments.formName) />
		<cfset var fieldName = safeFormName & arguments.validation.ClientFieldName />
		<cfset var fieldSelector = "$form_#safeFormName#.find("":input[name='#arguments.validation.ClientFieldName#']"")" />
		<cfset var valType = arguments.validation.ValType />
		<cfset var messageScript = "" />
		<cfif Len(arguments.customMessage) GT 0>
			<cfset messageScript = '"' & variables.Translator.translate(arguments.customMessage,arguments.locale) & '"' />
		</cfif>
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<cfset var params = arguments.validation.Parameters/>

		<cfif StructKeyExists(params,"propertyNames")>
			<cfsavecontent variable="theCondition">
				function(value,element,options) {
					var isValid = true;
					$(options).each(function(){					
						var propertyValue = $(':input[name='+this+']').getValue();
						if (propertyValue.length > 0){
							if (value.search(propertyValue) == -1){
								isValid = true
								//$.ValidateThis.log("Found " + element.name + "value in " + this);
							}else{
								isValid = false;
								//$.ValidateThis.log("Did not find " + element.name + "value in " + this);
							}
						}
						return isValid;
					});
					return isValid;
				}
			</cfsavecontent>
			<cfoutput>
				<cfsavecontent variable="theScript">
					$.validator.addMethod("#valType#", #theCondition#, #messageScript#);
					#fieldSelector#.rules("add", {
						 #valType# : #serializeJSON(listToArray(trim(params.propertyNames)))#
					});
			</cfsavecontent>
			</cfoutput>
		</cfif>
		<cfreturn theScript/>
	</cffunction>
</cfcomponent>