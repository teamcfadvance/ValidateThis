<cfcomponent displayname="ServerRuleValidator_URL" extends="validatethis.server.AbstractServerRuleValidator"  hint="I am responsible for performing URL validation.">
	<cfscript>
		public any function validate(any valObject){
			var theValue = arguments.valObject.getObjectValue();
			if (shouldTest(arguments.valObject) 
			     and not theValue.matches("(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'"".,<>?«»“”‘’])")){
				fail(arguments.valObject,createDefaultFailureMessage("#arguments.valObject.getPropertyDesc()# must be a valid URL."));
			}
		}
	</cfscript>
</cfcomponent>