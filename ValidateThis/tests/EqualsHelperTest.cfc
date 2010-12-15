<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			equalsHelper = CreateObject("component","ValidateThis.util.EqualsHelper").init();
			obj1 = CreateObject("component","fixture.APlainCFC_Fixture").init();
			obj2 = CreateObject("component","fixture.APlainCFC_Fixture").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="equalsShouldReturnTrueForTwoObjectsWithSameValues" access="public" returntype="void">
		<cfscript>
			assertEquals(true,equalsHelper.isEqual(obj1,obj2));
		</cfscript>  
	</cffunction>

	<cffunction name="equalsShouldReturnFalseForTwoObjectsWithDifferentValues" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			assertEquals(false,equalsHelper.isEqual(obj1,obj2));
		</cfscript>  
	</cffunction>

</cfcomponent>
