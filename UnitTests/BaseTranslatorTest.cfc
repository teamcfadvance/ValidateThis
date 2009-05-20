<!---
	
filename:		\VTDemo\UnitTests\BaseTranslatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I BaseTranslatorTest.cfc
				
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
<cfcomponent displayname="UnitTests.BaseTranslatorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset BaseTranslator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory() />
		<cfset BaseTranslator = getBeanFactory().getBean("ValidateThis").getBean("BaseTranslator") />
	</cffunction>

	<cffunction name="BaseTranslatorReturnsBaseTranslator" access="public" returntype="void">
		<cfscript>
			assertTrue(GetMetadata(BaseTranslator).name CONTAINS "BaseTranslator");
		</cfscript>  
	</cffunction>

	<cffunction name="GetLocalesReturnsEmptyStruct" access="public" returntype="void">
		<cfscript>
			assertTrue(StructIsEmpty(BaseTranslator.getLocales()));
		</cfscript>  
	</cffunction>

	<cffunction name="TranslateReturnsTranslatedText" access="public" returntype="void">
		<cfscript>
			theText = "Some text";
			assertEquals(BaseTranslator.translate(theText),theText);
		</cfscript>  
	</cffunction>

</cfcomponent>

