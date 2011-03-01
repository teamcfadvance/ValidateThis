<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.

--->

<cfcomponent displayname="usergroup" output="false" extends="AbstractTransferDecorator">
	
	<cffunction name="configure" access="private" returntype="void" hint="I am like init() but for decorators">
		<cfset super.configure() />
		<cfset variables.myInstance.ObjectDesc = "User Group" />
	</cffunction>

</cfcomponent>

