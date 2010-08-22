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
		function validate(valObject){
			var value = valObject.getObjectValue();
			var params = valObject.getParameters();
			var param = "";
			var minMatches = 1;
			var complexity = 0;
	
			if(NOT shouldTest(arguments.valObject)) return;
	
			if(structKeyExists(params,"minMatches")){
				minMatches = params.minMatches;
			}
			
			for(param in params){
				if(param.startsWith("pattern") and reFind(params[param],value) ){
					complexity++;
				}
				if(complexity eq minMatches) return;
			}
			
			if(complexity LT minMatches){
				fail(valObject,"#complexity# patterns were matched but #params.minMatches# were required");
			}
		}
	</cfscript>
</cfcomponent>