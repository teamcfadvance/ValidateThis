<!---
	
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.tests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("Size");
			parameters = {length="1"};
			validation.getParameters().returns(parameters);
			validation.hasParameter("length").returns(true);
			validation.getParameterValue("length",0).returns(1);
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForCorrectArrayLength" access="public" returntype="void">
		<cfscript>
			returns = [{test="test"}];
			validation.getObjectValue().returns(returns);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForIncorrectArrayLength" access="public" returntype="void">
		<cfscript>
			returns = [{test2="test2"},{test="test"}];
			validation.getObjectValue().returns(returns);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForCorrectStructCount" access="public" returntype="void">
		<cfscript>
			returns = {name="test"};
			validation.getObjectValue().returns(returns);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForIncorrectStructCount" access="public" returntype="void">
		<cfscript>
			returns = {test="name",name="test"};
			validation.getObjectValue().returns(returns);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForCorrectStringLength" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("t");
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>	
	
	<cffunction name="validateReturnsFalseForIncorrectStringLength" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("tt");
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyArrayIfRequired" access="public" returntype="void">
		<cfscript>
			validation.getIsRequired().returns(true);
			returns = [];
			validation.getObjectValue().returns(returns);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyStructIfRequired" access="public" returntype="void">
		<cfscript>
			validation.getIsRequired().returns(true);
			returns = {};
			validation.getObjectValue().returns(returns);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>


	<cffunction name="placeholderForTestsOfMinAndMaxParameters" access="public" returntype="void">
		<cfscript>
			fail("This is a placeholder for tests that need to be added for min and max parameter usage.");
		</cfscript>  
	</cffunction>

	
</cfcomponent>
