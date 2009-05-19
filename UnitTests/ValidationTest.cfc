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
			setBeanFactory();
			Transfer = getBeanFactory().getBean("Transfer");
			theObject = Transfer.new("user.user");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="ValidationShouldLoadFromStruct" access="public" returntype="void">
		<cfscript>
			TransientFactory = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.Param1 = 1;
			theValue = "Bob";
			theObject.setFirstName(theValue);
			Validation = TransientFactory.newValidation(theObject);
			Validation.load(valStruct);
			assertEquals(Validation.getValType(),valStruct.ValType);
			assertEquals(Validation.getPropertyName(),valStruct.PropertyName);
			assertEquals(Validation.getPropertyDesc(),valStruct.PropertyDesc);
			assertEquals(Validation.getParameters(),valStruct.Parameters);
			assertTrue(IsObject(Validation.getTheObject()));
			assertEquals(Validation.getObjectValue(),theValue);
			assertTrue(Validation.getIsSuccess());
		</cfscript>  
	</cffunction>

</cfcomponent>

