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
component 
{
	// Dependancy Injection
	property name="SessionStorage" inject="coldbox:plugin:SessionStorage";

	/**
	 * I run on every request
	 */
	void function requeststart( required event )
	{
		var rc = arguments.event.getCollection();
		
		// flag to indicate whether to use client side validation
		if ( StructKeyExists( rc, "nojs" ) )
		{
			variables.SessionStorage.setVar( "nojs", rc.nojs );
		}
		else
		{
			rc.nojs = variables.SessionStorage.getVar( "nojs", false );
		}
		
	}

}