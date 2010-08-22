<cfcomponent displayname="ServerRuleValidator_URL" extends="validatethis.server.AbstractServerRuleValidator"  hint="I am responsible for performing URL validation.">
	<cfscript>
		public any function validate(any valObject){
			var theValue = arguments.valObject.getObjectValue();
			if (shouldTest(arguments.valObject) and not isValid("URL",theValue)) {
				fail(arguments.valObject,createDefaultFailureMessage("#arguments.valObject.getPropertyDesc()# must be a valid URL."));
			}
		}
	</cfscript>
</cfcomponent>