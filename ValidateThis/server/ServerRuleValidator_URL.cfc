<cfcomponent output="false" displayname="ServerRuleValidator_URL" extends="AbstractServerRuleValidator"  hint="I am responsible for performing URL validation.">
	<cfscript>
		function validate(validation){
			var theValue = arguments.validation.getObjectValue();
			if (not shouldTest(arguments.validation)) return;
			if (not isValid("URL",theValue)) {
				fail(arguments.validation,createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must be a valid URL."));
			}
		}
	</cfscript>
</cfcomponent>