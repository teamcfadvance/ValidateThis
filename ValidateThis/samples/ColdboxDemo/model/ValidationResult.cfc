/*
	
	Copyright 2011, Bob Silverberg & John Whish
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
*/

/**
 * I am a specialised version of the default ValidateThis result object to show you what is possible
 * If you do want to use your own result object then use the resultPath configuration setting 
 * Using your own ValidationResult object is entirely optional
 */
component extends="ValidateThis.util.Result" 
{
	/**
	 * I check if the field has an error and if it does then I return
	 * the specific error as HTML to keep the view nice and clean
	 */
	string function renderErrorByField( required string fieldname )
	{
		var result = "";
		var failureCollection = getFailuresForUniform();
		var error = "";
		if ( StructKeyExists( failureCollection, arguments.fieldname ) )
		{
			result = '<p id="error-UserName" class="errorField bold">' & failureCollection[ arguments.fieldname ] & '</p>';
		}
		return result;
	}
}
