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
		<cfset setBeanFactory()>
		<cfset TransientFactory = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory") />
		<cfset Result = TransientFactory.newResult() />
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="testCreate" access="public" returntype="void">
		<cfscript>
			assertEquals(Result.getIsSuccess(),true);
			assertEquals(ArrayLen(Result.getFailures()),0);
			assertEquals(Result.getDummyValue(),"");
		</cfscript>  
	</cffunction>

	<cffunction name="testSet" access="public" returntype="void">
		<cfscript>
			DummyValue = "Dummy Value";
			Result.setDummyValue(DummyValue);
			assertEquals(Result.getIsSuccess(),true);
			assertEquals(ArrayLen(Result.getFailures()),0);
			assertEquals(Result.getDummyValue(),DummyValue);
		</cfscript>  
	</cffunction>

	<cffunction name="testAddFailure" access="public" returntype="void">
		<cfscript>
			Failure = StructNew();
			Failure.Code = 999;
			Result.addFailure(Failure);
			Result.setIsSuccess(false);
			assertEquals(Result.getIsSuccess(),false);
			Failures = Result.getFailures();
			assertEquals(ArrayLen(Failures),1);
			assertEquals(Failures[1].Code,999);
		</cfscript>  
	</cffunction>

</cfcomponent>

