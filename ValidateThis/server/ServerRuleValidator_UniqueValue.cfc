<!--- 
UniqueValue:
	ServerRuleValidator Implmenetation By Marc Esher:
	ClientRuleScripter Implementation By Adam Drew

Definition Usage Example:

<rule type="UniqueValue" failuremessage="Password may not contain your first or last name." >
	<param propertyNames="firstName,LastName"/>
</rule>
<rule type="UniqueValue" failuremessage="Password may not contain your username.">
	<param propertyNames="username" />
</rule>
<rule type="UniqueValue" failuremessage="Password may not contain your email address." >
	<param propertyNames="emailAddress"/>
</rule>
<rule type="UniqueValue" failuremessage="This better be ignored!" >
	<param propertyNames="thisPropertyDoesNotExist"/>
</rule>

See ClientRuleScripter_UniqueValue.cfc for client implmenetation
--->

<cfcomponent extends="validatethis.server.AbstractServerRuleValidator" hint="Fails if the validated property contains the value of another property">
	<cfscript>
		function validate(valObject){
			var value = arguments.valObject.getObjectValue();
			var params = arguments.valObject.getParameters();
			var property = "";

			if(	NOT shouldTest(arguments.valObject)	OR trim(value) eq "" OR NOT structKeyExists(params,"propertyNames")) return;

			var propertyNames = listToArray(params.propertyNames);
			for(property in propertyNames){
				var propValue = arguments.valObject.getObjectValue(property);
				if(propValue NEQ "" AND value contains propValue){
					fail(valObject, "The #arguments.valObject.getPropertyDesc()# must not contain the values of properties named: #params.propertyNames#. ");
				}
			}
		}
	</cfscript>
</cfcomponent>
