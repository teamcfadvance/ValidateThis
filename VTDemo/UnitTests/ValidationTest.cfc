<!---
	
filename:		\VTDemo\UnitTests\ValidationTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ValidationTest.cfc
				
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
<cfcomponent displayname="UnitTests.ValidationTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset theObject = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			variables.theObject = mock();
			/*
			variables.locales = {valA="A",valB="B"};
			variables.LoaderHelper.getResourceBundle("A").returns("A");
			variables.LoaderHelper.getResourceBundle("B").returns("B");
			variables.RBLocaleLoader = CreateObject("component","ValidateThis.core.RBLocaleLoader").init(variables.LoaderHelper);
			injectMethod(variables.RBLocaleLoader, this, "findLocaleFileOverride", "findLocaleFile");
			*/
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="ValidationShouldLoadFromStruct" access="public" returntype="void">
		<cfscript>
			injectMethod(variables.theObject, this, "getFirstName", "getFirstName");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.Param1 = 1;
			theValue = "Bob";
			Validation = CreateObject("component","ValidateThis.server.validation").init(variables.theObject,"getter");
			Validation.load(valStruct);
			assertEquals(valStruct.ValType,Validation.getValType());
			assertEquals(valStruct.PropertyName,Validation.getPropertyName());
			assertEquals(valStruct.PropertyDesc,Validation.getPropertyDesc());
			assertEquals(valStruct.Parameters,Validation.getParameters());
			assertTrue(IsObject(Validation.getTheObject()));
			assertEquals(theValue,Validation.getObjectValue());
			assertTrue(Validation.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="getFirstName">
		<cfreturn "Bob" />
	</cffunction>
	
	<cffunction name="getObjectValueWithGetterShouldWork" access="public" returntype="void">
		<cfscript>
			injectMethod(variables.theObject, this, "getFirstName", "getFirstName");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(variables.theObject,"getter");
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueWithGetterMissingPropertyShouldFail" access="public" returntype="void" mxunit:expectedException="validatethis.server.validation.propertyNotFound">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(variables.theObject,"getter");
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValuewheelsShouldWork" access="public" returntype="void">
		<cfscript>
			props = {FirstName="Bob"};
			variables.theObject.properties().returns(props);
			variables.theObject.$propertyvalue("FirstName").returns("Bob");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(variables.theObject,"wheels");
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

</cfcomponent>

