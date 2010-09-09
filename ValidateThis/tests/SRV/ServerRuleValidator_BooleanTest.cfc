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
			SRV = getSRV("Boolean");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidBoolean" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidBoolean" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("abc");
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("abc");
			validation.setFailureMessage("The PropertyDesc must be a valid boolean.").returns();
			SRV.validate(validation);
			validation.verifyTimes(1).setFailureMessage("The PropertyDesc must be a valid boolean."); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="failureMessageIsPrefixedByOverridenPrefix" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("Boolean","");
			validation.getObjectValue().returns("abc");
			validation.setFailureMessage("PropertyDesc must be a valid boolean.").returns();
			SRV.validate(validation);
			validation.verifyTimes(1).setFailureMessage("PropertyDesc must be a valid boolean."); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
