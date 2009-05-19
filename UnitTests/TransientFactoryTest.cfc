<!---
	
filename:		\VTDemo\UnitTests\TransientFactoryTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I TransientFactoryTest.cfc
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	2008-10-22	New																		BS

--->
<cfcomponent displayname="UnitTests.TransientFactoryTest"  extends="UnitTests.BaseTestCase">

	<cfset TransientFactory = "" />
	<cfset Transfer = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory()>
		<cfset TransientFactory = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory") />
		<cfset Transfer = getBeanFactory().getBean("Transfer") />
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

<!--- Begin Specific Test Cases --->
	
	<cffunction name="newResultReturnsResult" access="public" returntype="void">
		<cfscript>
		Result = variables.TransientFactory.newResult();
		assertTrue(GetMetadata(Result).name eq "validatethis.util.Result");
		</cfscript>
	</cffunction>

	
<!--- End Specific Test Cases --->

</cfcomponent>
