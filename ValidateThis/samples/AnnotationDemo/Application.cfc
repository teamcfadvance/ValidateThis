/*
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
*/

component output="false" {
	this.name = "ValidateThisAnnotationDemo";
	
	// set up a per application mapping to ValidateThis	
	this.mappings["/validatethis"] = ExpandPath( "../../../validatethis/" );
	
	this.ormEnabled = true;
	this.datasource = "VTDemo";
	this.ormSettings = {};
	this.ormSettings.dialect = "MySQLwithInnoDB";
	this.ormSettings.cfclocation = "model";
	this.ormSettings.flushatrequestend = false;
	this.ormSettings.automanageSession = false;
	this.ormSettings.dbcreate = "dropcreate";
	this.ormSettings.sqlscript = "import.sql";
	
	
	function onError(any exception, string eventName) {
		writeDump(arguments);
	} 

}
