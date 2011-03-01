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
 * I am a specialised version of the default ValidateThis BOValidator object to show you what is possible
 * If you do want to use your own BOValidator object then use the boValidatorPath configuration setting
 * Using your own BOValidator object is entirely optional 
 */
component extends="ValidateThis.core.BOValidator" 
{
	/**
	 * I check if the field is required (for the context if passed), if it is
	 * then I return HTML to keep the view nice and clean
	 */
	string function renderFieldIsRequired( required string fieldname, string context='' )
	{
		var result = "";
		
		if ( fieldIsRequired( arguments.fieldname, arguments.context ) )
		{
			result = '<em>*</em>';
		}
		return result;
	}
}
