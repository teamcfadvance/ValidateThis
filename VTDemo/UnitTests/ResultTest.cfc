<!---
	
filename:		\VTDemo\UnitTests\ResultTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ResultTest.cfc
				
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
<cfcomponent displayname="UnitTests.ResultTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset Result = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			MockTranslator = mock();
			MockTranslator.translate("{string}","{string}").returns("Translated Text");
			variables.Result = CreateObject("component","ValidateThis.util.Result").init(MockTranslator);
			//variables.Result.setTranslator(MockTranslator);
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="newResultLooksRight" access="public" returntype="void">
		<cfscript>
			assertEquals(variables.Result.getIsSuccess(),true);
			assertEquals(ArrayLen(variables.Result.getFailures()),0);
			assertEquals(variables.Result.getDummyValue(),"");
		</cfscript>  
	</cffunction>

	<cffunction name="setGetMissingPropertyWorks" access="public" returntype="void">
		<cfscript>
			DummyValue = "Dummy Value";
			variables.Result.setDummyValue(DummyValue);
			assertEquals(variables.Result.getDummyValue(),DummyValue);
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureAddsAFailure" access="public" returntype="void">
		<cfscript>
			Failure = StructNew();
			Failure.Code = 999;
			variables.Result.addFailure(Failure);
			variables.Result.setIsSuccess(false);
			assertEquals(variables.Result.getIsSuccess(),false);
			Failures = variables.Result.getFailures();
			assertEquals(ArrayLen(Failures),1);
			assertEquals(Failures[1].Code,999);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresReturnsTranslatedResult" access="public" returntype="void">
		<cfscript>
			Failure = StructNew();
			Failure.Message = "Any Message";
			variables.Result.addFailure(Failure);
			Failures = variables.Result.getFailures("any Locale");
			assertEquals("Translated Text",Failures[1].Message);
		</cfscript>  
	</cffunction>


</cfcomponent>

