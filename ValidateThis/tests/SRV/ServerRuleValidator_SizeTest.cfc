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
			
			// Define Validation Mockup Test Values
			parameters={};
			objectValue = "t";
			isRequired = true;
			hasMin = false;
			hasMax = false;
			hasLength = true;
			
			defaultMin = 1;
			defaultMax = 10;
			defaultLength = 1;
		</cfscript>
	</cffunction>
	
	<cffunction name="validationMockup" access="private">
		<cfscript>
			
			super.validationMockup();
			
			validation.hasParameter("length").returns(hasLength);
			validation.hasParameter("min").returns(hasMin);
			validation.hasParameter("max").returns(hasMax);
			
			validation.getParameterValue("length",0).returns(defaultLength);
			validation.getParameterValue("min",0).returns(defaultMin);
			validation.getParameterValue("max",0).returns(defaultMax);
			
		</cfscript>
	</cffunction>
	
	<cffunction name="validateTestIsReliableWithNoFalsePositives" access="public" returntype="void">
		<cfscript>
			objectValue = [{test="test"},{test2="test2"}];	
			isRequired=true;
			hasLength=true;
			hasMin = false;
			hasMax = false;
			parameters={length="1"};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForCorrectArrayLength" access="public" returntype="void">
		<cfscript>
			objectValue = [{test="test"}];	
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForIncorrectArrayLength" access="public" returntype="void">
		<cfscript>
			objectValue = [{test2="test2"},{test="test"}];
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForCorrectStructCount" access="public" returntype="void">
		<cfscript>
			objectValue = {name="test"};
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForIncorrectStructCount" access="public" returntype="void">
		<cfscript>
			objectValue = {test="name",name="test"};
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForCorrectStringLength" access="public" returntype="void">
		<cfscript>
			objectValue  = "t";
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>	
	
	<cffunction name="validateReturnsFalseForIncorrectStringLength" access="public" returntype="void">
		<cfscript>
			objectValue = "tt";
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyArrayIfRequired" access="public" returntype="void">
		<cfscript>
			isRequired = true;
			objectValue = [];			
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyStructIfRequired" access="public" returntype="void">
		<cfscript>
			isRequired = true;
			objectValue = {};
			hasLength=true;
			hasMin = false;
			hasMax = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			hasLength=true;
			hasMin = false;
			hasMax = false;
			isRequired = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			hasLength=true;
			hasMin = false;
			hasMax = false;
			isRequired = true;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValueInRange" access="public" returntype="void">
		<cfscript>
			objectValue = "test";
			parameters={min=1,max=10};
			hasMin = true;
			hasMax = true;
			hasLength = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false);
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForValueOutOfRangeLow" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			parameters={min=1,max=10};
			hasMin = true;
			hasMax = true;
			hasLength = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false);
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForValueOutOfRangeHigh" access="public" returntype="void">
		<cfscript>
			objectValue = "asdfasdfasdfasdfasdf";
			parameters={min=1,max=10};
			hasMin = true;
			hasMax = true;
			hasLength = false;
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false);
		</cfscript>  
	</cffunction>
	
</cfcomponent>
