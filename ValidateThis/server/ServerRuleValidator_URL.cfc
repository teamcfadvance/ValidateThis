<cfcomponent displayname="ServerRuleValidator_URL" extends="AbstractServerRuleValidator"  hint="I am responsible for performing URL validation.">
	<cfscript>
		public any function validate(any validation){
			var theValue = arguments.validation.getObjectValue();
			if (shouldTest(arguments.validation) and not isValid("URL",theValue)) {
				fail(arguments.validation,createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must be a valid URL."));
			}
		}
	</cfscript>
</cfcomponent>