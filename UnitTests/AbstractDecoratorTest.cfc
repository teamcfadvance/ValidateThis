<!---
	
filename:		\VTDemo\UnitTests\AbstractDecoratorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I AbstractDecoratorTest.cfc
				
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
<cfcomponent displayname="UnitTests.AbstractDecoratorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset Transfer = "" />
	<cfset UserTO = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory() />
		<cfset Transfer = getBeanFactory().getBean("Transfer") />
		<cfset UserTO = Transfer.new("user.user") />
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="BOValidatorShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			assertTrue(GetMetadata(UserTO.getValidator()).name CONTAINS "BOValidator");
			assertEquals(UserTO.getValidator().getObjectType(),"user.user");
		</cfscript>  
	</cffunction>

	<cffunction name="testTestCondition" access="public" returntype="void">
		<cfscript>
			Result = UserTO.TestCondition("true");
			assertTrue(Result);
			Result = UserTO.TestCondition("false");
			assertFalse(Result);
			Result = UserTO.TestCondition("1 EQ 1");
			assertTrue(Result);
			Result = UserTO.TestCondition("1 EQ 2");
			assertFalse(Result);
			Result = UserTO.TestCondition("getClassName() EQ 'user.user'");
			assertTrue(Result);
			Result = UserTO.TestCondition("getClassName() EQ 'wrong class name'");
			Result = UserTO.TestCondition("1 EQ 2");
			assertFalse(Result);
		</cfscript>  
	</cffunction>

</cfcomponent>

