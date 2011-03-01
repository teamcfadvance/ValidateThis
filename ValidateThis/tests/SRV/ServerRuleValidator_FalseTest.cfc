<!---
	
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Adam Drew
	
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
			SRV = getSRV("False");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForFalseBoolean" access="public" returntype="void">
		<cfscript>
			objectValue = false;
            
            configureValidationMock();
			SRV.validate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForTrueBoolean" access="public" returntype="void">
		<cfscript>
			objectValue = true;
            
            configureValidationMock();
			SRV.validate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidBoolean" access="public" returntype="void">
		<cfscript>
			objectValue = "abc";
            
            configureValidationMock();
			SRV.validate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	
	<!--- TODO: Test Failure Messages
	
	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("abc");
			validation.setFailureMessage("The PropertyDesc must be a valid false boolean.").returns();
			SRV.validate(validation);
			validation.verifyTimes(2).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage("The PropertyDesc must be a valid false boolean."); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="failureMessageIsPrefixedByOverridenPrefix" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("AssertFalse","");
			validation.getObjectValue().returns("abc");
			validation.setFailureMessage("PropertyDesc must be a valid false boolean.").returns();
			SRV.validate(validation);
			validation.verifyTimes(3).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage("PropertyDesc must be a valid false boolean."); 
		</cfscript>  
	</cffunction> --->
	
</cfcomponent>
