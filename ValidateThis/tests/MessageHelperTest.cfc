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
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			msgHelper = CreateObject("component","ValidateThis.core.MessageHelper").init();
		</cfscript>
	</cffunction>

	<cffunction name="messageFormatDoesExpectedTextReplacementAndFormatting" access="public" returntype="void">
		<cfscript>
			locale = "en_US";
			theDate = now();
			pattern = "Hey, {1}, you call that a {2}, {3,number,currency}, {4,date,full}, {4,time,medium}, {5,number,integer}?";
			expectedText = "Hey, Bob, you call that a Name, $4.00, #dateFormat(theDate,'full')#, #timeFormat(theDate,'medium')#, 3?";
			formatted = msgHelper.messageFormat(pattern,["Bob","Name",4,theDate,3.1415926]);
			assertEquals(expectedText,formatted,locale);
		</cfscript>  
	</cffunction>
	
</cfcomponent>

