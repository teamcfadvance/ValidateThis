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

<cfcomponent extends="AbstractServerRuleValidator" hint="Fails if the validated property contains the value of another property">
	<cfscript>
		function validate(validation){
			var value = arguments.validation.getObjectValue();
			var params = arguments.validation.getParameters();
			var property = "";
			var propIndex = "";
			var propValue = "";
            var propertyNames = listToArray(arguments.validation.getParameterValue("propertyNames"));

			if (not shouldTest(arguments.validation)) {
			   return;
			} else if (shouldTest(arguments.validation) and len(value) eq 0){
			     fail(validation, createDefaultFailureMessage(""));
			}
			
			for (propIndex = 1; propIndex <= ArrayLen(propertyNames); propIndex++) {
				property = propertyNames[propIndex];
				propValue = arguments.validation.getObjectValue(property);
				if(propValue NEQ "" AND value contains propValue){
					fail(validation, createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must not contain the values of properties named: #params.propertyNames#."));
				}
			}
		}
	</cfscript>
</cfcomponent>
