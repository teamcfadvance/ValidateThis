<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="propertyHasValueShouldReturnTrueIfPropertyPopulated" access="public" returntype="void">
		<cfscript>
			collaborator = CreateObject("component","ValidateThis.core.Version").init();
			SRV = getSRV("required");
			makePublic(collaborator,"getVersion");
			makePublic(SRV,"propertyHasValue");
		</cfscript>  
	</cffunction>
	
	<cffunction name="getSRV" access="private" returntype="Any">
		<cfargument name="ValType" />
		
		<cfreturn CreateObject("component","ValidateThis.server.ServerRuleValidator_#arguments.valType#").init("The ") />
		
	</cffunction>

</cfcomponent>


