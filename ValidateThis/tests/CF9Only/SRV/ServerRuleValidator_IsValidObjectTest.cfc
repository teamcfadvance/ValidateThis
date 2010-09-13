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
			SRV = getSRV("IsValidObject");
			
			// Define Validation Mockup Test Values
			parameters={};
			context="*";
			objectValue = {};
			isRequired = true;
			validUserMockup();
			invalidUserMockup();
			validCompanyMockup();
			invalidCompanyMockup();
			noruleCompanyMockup();
			
		</cfscript>
	</cffunction>
	
	<cffunction name="validationMockup" access="private">
		<cfscript>
			mockfacade = true;
			super.validationMockup();
			validation.getParameterValue("context","*").returns(context);
			validation.getParameterValue("context").returns(context);
		</cfscript>
	</cffunction>
	
	<cffunction name="validCompanyMockup" access="private">
		<cfscript>
			validCompany = createObject("component","validatethis.tests.Fixture.models.cf9.vtml.Company");
			validCompany.setCompanyName("Adam Drew");
		</cfscript>
	</cffunction>
	<cffunction name="invalidCompanyMockup" access="private">
		<cfscript>
			invalidCompany = createObject("component","validatethis.tests.Fixture.models.cf9.vtml.Company");
			invalidCompany.setCompanyName("A");
		</cfscript>
	</cffunction>
	<cffunction name="noruleCompanyMockup" access="private">
		<cfscript>
			noruleCompany = createObject("component","validatethis.tests.Fixture.models.cf9.norules.Company");
			noruleCompany.setCompanyName("A");
		</cfscript>
	</cffunction>
	
	<cffunction name="validUserMockup" access="private">
		<cfscript>
			validUser = createObject("component","validatethis.tests.Fixture.models.cf9.json.User").init();
			validUser.setUserName("epner81@gmail.com");
		</cfscript>
	</cffunction>
	
	<cffunction name="invalidUserMockup" access="private">
		<cfscript>
			invalidUser = createObject("component","validatethis.tests.Fixture.models.cf9.json.User").init();
			invalidUser.setUserName("");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateTestIsReliableWithNoFalsePositives" access="public" returntype="void">
		<cfscript>
			objectValue = {}; // I know an empty struct should fail here. but does it?	
			isRequired=true;

			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyStruct" access="public" returntype="void">
		<cfscript>
			objectValue = {};	
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyArray" access="public" returntype="void">
		<cfscript>
			objectValue = [];	
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArray" access="public" returntype="void">
		<cfscript>			
			objectValue = [validCompany,invalidCompany];	

			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidArrayOfOneObjectType" access="public" returntype="void">
		<cfscript>			
			validCompany2 = duplicate(validCompany);
			//validCompany2.setCompanyName("Majik Solutions");
			objectValue = [validCompany,validCompany2];	

			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidArrayMixedObjectTypes" access="public" returntype="void">
		<cfscript>			
			validCompany2 = duplicate(validCompany);
			validUser2 = duplicate(validUser);
			
			objectValue = [validCompany,validUser,validCompany2,validUser2];	

			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
			
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArrayOfOneObjectType" access="public" returntype="void">
		<cfscript>			
			invalidCompany2  = duplicate(invalidCompany);
			objectValue = [invalidCompany,invalidCompany2];	

			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(arrayLen(objectValue)).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArrayMixedObjectTypes" access="public" returntype="void">
		<cfscript>			
			invalidCompany2 = duplicate(invalidCompany);
			invalidUser2 = duplicate(invalidUser);
			
			objectValue = [invalidCompany,invalidUser,invalidCompany2,invalidUser2];	

			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(arrayLen(objectValue)).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<!--- Integration Tests!!! --->
	<cffunction name="validateReturnsTrueForValidObjectWithNoValidationParameters" access="public" returntype="void">
		<cfscript>
			objectValue = validCompany;
			
			parameters={};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForObjectWithNoRules" access="public" returntype="void">
		<cfscript>
			objectValue = noruleCompany;
			
			parameters={};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForValidObjectWithVTML" access="public" returntype="void">
		<cfscript>
			objectValue = validCompany;
			
			parameters={};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsFalseForInvalidObjectWithVTML" access="public" returntype="void">
		<cfscript>
			objectValue = invalidCompany;
			
			parameters={};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForValidObjectWithJSON" access="public" returntype="void">
		<cfscript>
			objectValue = validUser;
			
			parameters={};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsFalseForInvalidObjectWithJSON" access="public" returntype="void">
		<cfscript>
			objectValue = invalidUser;
			
			parameters={};
			
			validationMockup();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
