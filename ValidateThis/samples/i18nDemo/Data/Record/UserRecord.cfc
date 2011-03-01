
<cfcomponent hint="I am the database agnostic custom Record object for the User object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.i18nDemo.Record.UserRecord" >
	<!--- Place custom code here, it will not be overwritten --->

	<cfset variables.myInstance = StructNew() />	
	<cfset setVerifyPassword("") />

	<cffunction name="CheckDupNickname" access="public" output="false" returntype="any" hint="Checks for a duplicate UserName.">

		<!--- This is just a "mock" method to test out the custom validation type --->
		<cfset var ReturnStruct = StructNew() />
		<cfset ReturnStruct.IsSuccess = false />
		<cfset ReturnStruct.FailureMessage = "That Nickname has already been used. Try to be more original!" />
		<cfif getNickname() NEQ "BobRules">
			<cfset ReturnStruct = StructNew() />
			<cfset ReturnStruct.IsSuccess = true />
		</cfif>
		<cfreturn ReturnStruct />		
	</cffunction>

	<cffunction name="setVerifyPassword" returntype="void" access="public" output="false">
		<cfargument name="VerifyPassword" type="any" required="true" />
		<cfset variables.myInstance.VerifyPassword = arguments.VerifyPassword />
	</cffunction>
	<cffunction name="getVerifyPassword" access="public" output="false" returntype="any">
		<cfreturn variables.myInstance.VerifyPassword />
	</cffunction>

	
</cfcomponent>
	
