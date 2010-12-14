<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cfset Result = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			MockTranslator = mock();
			MockTranslator.translate("{string}","{string}").returns("Translated Text");
			result = CreateObject("component","ValidateThis.util.Result").init(MockTranslator);
			//result.setTranslator(MockTranslator);
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="newResultShouldContainDefaultPropertyValues" access="public" returntype="void">
		<cfscript>
			assertEquals(result.getIsSuccess(),true);
			assertEquals(ArrayLen(result.getFailures()),0);
			assertEquals(result.getDummyValue(),"");
		</cfscript>  
	</cffunction>

	<cffunction name="missingPropertyHandlersShouldBeAbleToSetAndGetArbitraryProperties" access="public" returntype="void">
		<cfscript>
			DummyValue = "Dummy Value";
			result.setDummyValue(DummyValue);
			assertEquals(result.getDummyValue(),DummyValue);
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureWithValidStructShouldAddAFailure" access="public" returntype="void">
		<cfscript>
			failure = StructNew();
			failure.Code = 999;
			failure.Message = "abc";
			result.addFailure(failure);
			result.setIsSuccess(false);
			assertEquals(result.getIsSuccess(),false);
			failures = result.getFailures();
			assertEquals(ArrayLen(failures),1);
			assertEquals(failures[1].Code,999);
			assertEquals(failures[1].Message,"abc");
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureMissingMessageKeyShouldThrowAnException" access="public" returntype="void"
	mxunit:expectedException="ValidateThis.util.Result.invalidFailureStruct">
		<cfscript>
			failure = StructNew();
			result.addFailure(failure);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresShouldReturnArrayWithFailures" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailures();
			assertEquals(3,arrayLen(failures));
			assertEquals("First Message",failures[1].Message);
			assertEquals("Second Message",failures[2].Message);
			assertEquals("Third Message",failures[3].Message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresForLocaleShouldReturnArrayWithTranslatedMessages" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailures("any Locale");
			assertEquals(3,arrayLen(failures));
			assertEquals("Translated Text",failures[1].Message);
			assertEquals("Translated Text",failures[2].Message);
			assertEquals("Translated Text",failures[3].Message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesShouldReturnArrayOfMessages" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessages();
			assertEquals(3,arrayLen(failures));
			assertEquals("First Message",failures[1]);
			assertEquals("Second Message",failures[2]);
			assertEquals("Third Message",failures[3]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresAsStringShouldReturnListOfMessagesWithABRDelimiter" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsString();
			assertEquals("First Message<br />Second Message<br />Third Message",failures);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresAsStringShouldReturnListOfMessagesWithCustomDelimiter" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsString("|");
			assertEquals("First Message|Second Message|Third Message",failures);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldShouldReturnArraysOfFailuresPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresByField();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.fieldA[1].message);
			assertEquals("Second Message",failures.fieldA[2].message);
			assertEquals("Third Message",failures.fieldB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByPropertyShouldReturnArraysOfFailuresPerPropertyName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresByProperty();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.propertyA[1].message);
			assertEquals("Second Message",failures.propertyA[2].message);
			assertEquals("Third Message",failures.propertyB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldShouldReturnArraysOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByField();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.fieldA[1]);
			assertEquals("Second Message",failures.fieldA[2]);
			assertEquals("Third Message",failures.fieldB[1]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByPropertyShouldReturnArraysOfMessagesPerPropertyName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByProperty();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.propertyA[1]);
			assertEquals("Second Message",failures.propertyA[2]);
			assertEquals("Third Message",failures.propertyB[1]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldWithDelimeterShouldReturnStringsOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByField(delimiter="<br />");
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.fieldA);
			assertEquals("Third Message",failures.fieldB);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByPropertyWithDelimeterShouldReturnStringsOfMessagesPerPropertyName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByProperty(delimiter="<br />");
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.propertyA);
			assertEquals("Third Message",failures.propertyB);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldWithLimitOf1ShouldReturnLimitedArraysOfFailuresPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailuresByField(limit=1);
			assertEquals(2,structCount(failures));
			assertEquals(1,arrayLen(failures.fieldA));
			assertEquals(1,arrayLen(failures.fieldB));
			assertEquals("First Message",failures.fieldA[1].message);
			assertEquals("Third Message",failures.fieldB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldWithLimitOf2ShouldReturnLimitedArraysOfFailuresPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailuresByField(limit=2);
			assertEquals(2,structCount(failures));
			assertEquals(2,arrayLen(failures.fieldA));
			assertEquals(2,arrayLen(failures.fieldB));
			assertEquals("First Message",failures.fieldA[1].message);
			assertEquals("Second Message",failures.fieldA[2].message);
			assertEquals("Third Message",failures.fieldB[1].message);
			assertEquals("Third Message",failures.fieldB[2].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldWithLimitOf2ShouldReturnLimitedArraysOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailureMessagesByField(limit=2);
			assertEquals(2,structCount(failures));
			assertEquals(2,arrayLen(failures.fieldA));
			assertEquals(2,arrayLen(failures.fieldB));
			assertEquals("First Message",failures.fieldA[1]);
			assertEquals("Second Message",failures.fieldA[2]);
			assertEquals("Third Message",failures.fieldB[1]);
			assertEquals("Third Message",failures.fieldB[2]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldWithLimitOf2AndDelimiterShouldReturnLimitedStringsOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailureMessagesByField(limit=2,delimiter="<br />");
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.fieldA);
			assertEquals("Third Message<br />Third Message",failures.fieldB);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresAsStructShouldReturnStructWithKeysPerFieldAndBRDelimiters" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsStruct();
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.fieldA);
			assertEquals("Third Message",failures.fieldB);
		</cfscript>  
	</cffunction>
	
	<cffunction name="addResultShouldAppendFailuresFromAPassedInResultObject" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			assertEquals(3,arrayLen(result.getFailures()));
			debug(result.getRawFailures());
			result2 = CreateObject("component","ValidateThis.util.Result").init(MockTranslator);
			addMultipleFailures(result2);
			debug(result2.getRawFailures());
			result.addResult(result2);
			debug(result.getRawFailures());
			assertEquals(6,arrayLen(result.getFailures()));
		</cfscript>  
	</cffunction>
	
	<cffunction name="addMultipleFailures" access="private" returntype="void">
		<cfargument name="toResult" required="false" default="#result#" >
		<cfscript>
			failure = StructNew();
			failure.Message = "First Message";
			failure.PropertyName = "propertyA";
			failure.ClientFieldName = "fieldA";
			arguments.toResult.addFailure(failure);
			failure = StructNew();
			failure.Message = "Second Message";
			failure.PropertyName = "propertyA";
			failure.ClientFieldName = "fieldA";
			arguments.toResult..addFailure(failure);
			failure = StructNew();
			failure.Message = "Third Message";
			failure.PropertyName = "propertyB";
			failure.ClientFieldName = "fieldB";
			arguments.toResult..addFailure(failure);
		</cfscript>
	</cffunction>


</cfcomponent>

