<cfcomponent name="ValidateThis" accessors="true" output="false" extends="coldbox.system.remote.ColdboxProxy">

	<cffunction name="getInitializationScript" access="remote" output="false" returnformat="plain" returntype="string">
			<cfreturn getValidateThis().getInitializationScript(argumentCollection=arguments)/>
	</cffunction>

	<cffunction name="getValidationScript" access="remote" output="false" returnformat="plain" returntype="string">
			<cfreturn getValidateThis().getValidationScript(argumentCollection=arguments)/>
	</cffunction>

	<cffunction name="getValidationStruct" access="remote" output="false" returnformat="JSON" returntype="any">
			<cfreturn getValidateThis().getValidationStruct(argumentCollection=arguments)/>
	</cffunction>

	<cffunction name="getValidationJSON" access="remote" output="false" returnformat="JSON" returntype="string">
			<cfreturn getValidateThis().getValidationJSON(argumentCollection=arguments)/>
	</cffunction>

	<cffunction name="getValidationVersion" access="remote" output="false" returnformat="plain" returntype="any">
		<cfreturn getValidateThis().getVersion()/>
	</cffunction>

	<cffunction name="validate" access="remote" output="false" returnformat="json" returntype="any">
		<cfreturn getValidateThis().validate(argumentCollection=arguments)/>
	</cffunction>
	
	<cffunction name="getValidateThis" output="false" access="private" returntype="any">
		<cfreturn getColdBoxOCM().get("ValidateThis")>
	</cffunction>

</cfcomponent>