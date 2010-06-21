<!---
	
filename:		\VTDemo\UnitTests\ValidateThisTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ValidateThisTest.cfc
				
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
<cfcomponent extends="UnitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(StructNew()) />
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="getVersionReturnsCurrentVersion" access="public" returntype="void">
		<cfscript>
			assertEquals("0.94",ValidateThis.getVersion());
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlCfmRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture_cfm");
			BOValidator = ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlFileIsInAConfiguredFolder" access="public" returntype="void">
		<cfscript>
			VTConfig = 	{definitionPath=getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			theObject = createObject("component","Fixture.ObjectWithSeparateRulesFile");
			BOValidator = ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="newResultShouldReturnBuiltInResultObjectWithDefaultConfig" access="public" returntype="void">
		<cfscript>
			result = ValidateThis.newResult();
			assertEquals("validatethis.util.Result",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="newResultShouldReturnCustomResultObjectWhenspecifiedViaConfig" access="public" returntype="void">
		<cfscript>
			vtConfig = {ResultPath="UnitTests.Fixture.CustomResult"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(vtConfig);
			result = ValidateThis.newResult();
			assertEquals("UnitTests.Fixture.CustomResult",GetMetadata(result).name);
		</cfscript>
	</cffunction>

</cfcomponent>

