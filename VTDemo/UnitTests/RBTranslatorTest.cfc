
<!---
	
filename:		\VTDemo\UnitTests\RBTranslatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I RBTranslatorTest.cfc
				
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
<cfcomponent displayname="UnitTests.RBTranslatorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset RBTranslator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset localeMap = {en_US="/ValidateThis/rbs/en_US.properties",fr_FR="/ValidateThis/rbs/fr_FR.properties"} />
		<cfset validateThisConfig = {localeMap = localeMap,TranslatorPath="ValidateThis.core.RBTranslator"} />
		<cfset ValidateThis = createObject("component","ValidateThis.ValidateThis").init(validateThisConfig) />
		<cfset RBTranslator = ValidateThis.getBean("Translator") />
	</cffunction>

	<cffunction name="RBTranslatorReturnsRBTranslator" access="public" returntype="void">
		<cfscript>
			assertTrue(GetMetadata(RBTranslator).name CONTAINS "RBTranslator");
		</cfscript>  
	</cffunction>

	<cffunction name="safeKeyReturnsProperKey" access="public" returntype="void">
		<cfscript>
			expected = "SafeKey";
			assertEquals(expected,RBTranslator.safeKey("SafeKey"));
			assertEquals(expected,RBTranslator.safeKey("Safe!Key"));
			assertEquals(expected,RBTranslator.safeKey("Safe.Key$"));
			expected = "Safe_Key";
			assertEquals(expected,RBTranslator.safeKey("Safe!_Key"));
			assertEquals(expected,RBTranslator.safeKey("Safe Key"));
		</cfscript>  
	</cffunction>

	<cffunction name="GetLocalesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			assertEquals(StructCount(RBTranslator.getLocales()),2);
		</cfscript>  
	</cffunction>

	<cffunction name="TranslateReturnsTranslatedText" access="public" returntype="void">
		<cfscript>
			theKey = "SomeText";
			locale = "en_US";
			expectedText = "Some Text";
			assertEquals(RBTranslator.translate(theKey,locale),expectedText);
			locale = "fr_FR";
			expectedText = "Some Text In French";
			assertEquals(RBTranslator.translate(theKey,locale),expectedText);
		</cfscript>  
	</cffunction>
	
	<cffunction name="MissingLocaleThrowsExpectedException" access="public" returntype="void" mxunit:expectedException="validatethis.core.RBTranslator.LocaleNotDefined">
		<cfscript>
			theKey = "SomeText";
			locale = "bob";
			expectedText = "bob";
			assertEquals(RBTranslator.translate(theKey,locale),expectedText);
		</cfscript>  
	</cffunction>

	<cffunction name="MissingKeyThrowsExpectedException" access="public" returntype="void" mxunit:expectedException="validatethis.core.RBTranslator.KeyNotDefined">
		<cfscript>
			theKey = "NotDefined";
			locale = "en_US";
			expectedText = "bob";
			assertEquals(RBTranslator.translate(theKey,locale),expectedText);
		</cfscript>  
	</cffunction>

</cfcomponent>

