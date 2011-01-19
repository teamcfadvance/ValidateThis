/*
	
	Copyright 2011, John Whish & Bob Silverberg
	
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
	// Application properties
	this.name = "ValidateThisColdboxi18nDemoTest";
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan( 0, 0, 30, 0 );

	// mappings for testing	
	this.mappings["/approot"] = ExpandPath( "../" );
	this.mappings["/model"] = ExpandPath( "../model/" );
	this.mappings["/validatethis"] = ExpandPath( "../../../../validatethis/" );

	// ORM Setup
	this.datasource = "VTDemo";
	this.ormenabled = true;
	this.ormSettings = {
		cfclocation = this.mappings["/model"],
		dialect = "MySQLwithInnoDB",
		flushAtRequestEnd = false
	};

}