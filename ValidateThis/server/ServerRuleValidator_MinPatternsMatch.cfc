<!--- 

Example Usage:

<rule type="MinPatternsMatch">
	<param name="minMatches" value="3" />
	<param name="pattern_lowerCaseLetter" value="[a-z]" />
	<param name="pattern_upperCaseLetter" value="[A-Z]" />
	<param name="pattern_digit" value="[\d]" />
	<param name="pattern_punct" value="[[:punct:]]" />
</rule>

 --->

<cfcomponent output="false" extends="AbstractServerRuleValidator" hint="Evaluates each regex pattern. Any parameter starting with the word 'pattern' is considered. Validation fails if at least X patterns match, where 'X' is specified as the 'minMatches' parameter">
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
				fail(validation,"#complexity# patterns were matched but #minMatches# were required.");
			}
		}
	</cfscript>
</cfcomponent>