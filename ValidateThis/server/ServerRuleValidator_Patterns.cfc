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

<cfcomponent extends="AbstractServerRuleValidator" hint="Evaluates each regex pattern. Any parameter starting with the word 'pattern' is considered. Validation fails if at least X patterns match, where 'X' is specified as the 'minMatches' parameter">
	<cfscript>
		function validate(validation){
			var value = arguments.validation.getObjectValue();
			var params = arguments.validation.getParameters();
			var param = "";
			var minMatches = arguments.validation.getParameterValue("minMatches",1);
			var complexity = 0;
	
			if(NOT shouldTest(arguments.validation)) return;
			
			for(param in params){
				if(param.startsWith("pattern") and reFind(params[param],value) ){
					complexity++;
				}
				if(complexity eq minMatches) return;
			}
			
			if(complexity LT minMatches){
				fail(validation,"#complexity# patterns were matched but #minMatches# were required");
			}
		}
	</cfscript>
</cfcomponent>