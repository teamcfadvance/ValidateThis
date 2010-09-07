<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			srv = createObject("component","ValidateThis.server.ServerRuleValidator_Integer").init("The ");
			validation = mock();
			validation.setIsSuccess(false).returns();
			validation.getPropertyDesc().returns("Something");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidInteger" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns(1);
			srv.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidInteger" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("abc");
			srv.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

</cfcomponent>


