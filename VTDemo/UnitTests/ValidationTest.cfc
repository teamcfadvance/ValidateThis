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
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="ValidationShouldLoadFromStruct" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.Param1 = 1;
			theValue = "Bob";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
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

	<cffunction name="getObjectValueCFCNoArgumentShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCWithPropertyNameArgumentShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getLastName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Silverberg",Validation.getObjectValue("LastName"));
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCWithAbstractGetterShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.CFCWithAbstractGetter_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getProperty('FirstName')");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueMissingPropertyShouldFail" access="public" returntype="void" mxunit:expectedException="validatethis.server.validation.propertyNotFound">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "Blah";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueWheelsShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("$propertyvalue('WheelsName')");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "WheelsName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueGroovyShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getGroovyName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "GroovyName";
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getIsRequiredShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.PropertyName = "FirstName";
			valStruct.isRequired = true;
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals(true,Validation.getIsRequired());
		</cfscript>  
	</cffunction>

	<cffunction name="getIsRequiredShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.PropertyName = "FirstName";
			valStruct.isRequired = false;
			Validation = CreateObject("component","ValidateThis.server.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals(false,Validation.getIsRequired());
		</cfscript>  
	</cffunction>

</cfcomponent>

