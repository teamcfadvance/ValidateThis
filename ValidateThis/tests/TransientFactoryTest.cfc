<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent  extends="UnitTests.BaseTestCase">

	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="createTransientFactory" access="private" returntype="any">
		<cfargument name="addToConfig" type="struct" required="false" default="#structNew()#" />
		<cfscript>
			ValidateThisConfig = getVTConfig();
			structAppend(ValidateThisConfig,arguments.addToConfig,true);
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			transientFactory = validationFactory.getBean("transientFactory");
		</cfscript>
	</cffunction>


	<cffunction name="newResultShouldReturnBuiltInResultObject" access="public" returntype="void">
		<cfscript>
			createTransientFactory();
			result = variables.transientFactory.newResult();
			assertEquals("validatethis.util.Result",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="newResultShouldReturnCustomResultObjectWhenOverrideInPlace" access="public" returntype="void">
		<cfscript>
			extra = {ResultPath="UnitTests.Fixture.CustomResult"};
			createTransientFactory(extra);
			result = variables.transientFactory.newResult();
			assertEquals("UnitTests.Fixture.CustomResult",GetMetadata(result).name);
		</cfscript>
	</cffunction>

</cfcomponent>
