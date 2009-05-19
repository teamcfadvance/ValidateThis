<!---
	
filename:		\VTDemo\UnitTests\ValidationFactoryTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ValidationFactoryTest.cfc
				
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
<cfcomponent displayname="UnitTests.ValidationFactoryTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset ValidationFactory = "" />
	
	<!--- Need to rewrite without Coldspring
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory()>
		<cfset ValidationFactory = getBeanFactory().getBean("ValidateThis").getBean("ValidationFactory") />
		<!--- Inject debugarray --->
		<cfset ValidationFactory.debugarray = this.debugarray />
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="GetValidatorReturnsComposedValidator" access="public" returntype="void">
		<cfscript>
			defPath = ReReplaceNoCase(getCurrentTemplatePath(),"([\w\\]+?)(UnitTests\\)([\w\W]+)","\1Model\");
			Validator = ValidationFactory.getValidator("user.user",defPath);
			assertTrue(GetMetadata(Validator).name CONTAINS "BOValidator");
			assertTrue(GetMetadata(Validator.getXMLFileReader()).name CONTAINS "validatethis.core.XMLFileReader");
			assertTrue(GetMetadata(Validator.getServerValidator()).name CONTAINS "validatethis.server.ServerValidator");
			assertTrue(GetMetadata(Validator.getClientValidator()).name CONTAINS "validatethis.client.ClientValidator");
			assertEquals(Validator.getObjectType(),"user.user");
		</cfscript>  
	</cffunction>
	--->

</cfcomponent>

