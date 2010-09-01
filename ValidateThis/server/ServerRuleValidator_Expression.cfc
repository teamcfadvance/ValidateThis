<cfcomponent output="false" name="ServerRuleValidator_Expression" extends="AbstractServerRuleValidator">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />

		<cfset var theObject = arguments.valObject.getTheObject() />
		<cfset var Parameters = arguments.valObject.getParameters() />
		<cfset var expr = Parameters.expression />
		<cfif NOT theObject.testCondition(expr)>
			<cfset fail(valObject, valObject.getFailureMessage()) />
		</cfif>
		
	</cffunction>

</cfcomponent>
	
