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
 * I am the ColdBox proxy used for remote calls
 */
component extends="coldbox.system.remote.ColdboxProxy"
{

	remote any function checkDupNickname( required string callback, required string nickname )
	{
		// note: result must be quoted as javascript is case sensitive
		var result = "true";
		
		// in real code you'd call the service layer or use process()
		if ( arguments.nickname == "BobRules" )
		{
			result = "false";
		}
		return "#arguments.callback#(#result#)";
	}

}
