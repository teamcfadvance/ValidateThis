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
			translator = mock();
			transientFactory = createObject("component","ValidateThis.util.TransientFactoryNoCS").init(translator,"ValidateThis.util.Result");
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="newResultShouldReturnBuiltInResultObject" access="public" returntype="void">
		<cfscript>
			result = variables.transientFactory.newResult();
			assertEquals("validatethis.util.Result",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="newResultShouldReturnCustomResultObjectWhenOverrideInPlace" access="public" returntype="void">
		<cfscript>
			transientFactory = createObject("component","ValidateThis.util.TransientFactoryNoCS").init(translator,"UnitTests.Fixture.APlainCFC_Fixture");
			result = variables.transientFactory.newResult();
			assertEquals("UnitTests.Fixture.APlainCFC_Fixture",GetMetadata(result).name);
		</cfscript>
	</cffunction>

</cfcomponent>
