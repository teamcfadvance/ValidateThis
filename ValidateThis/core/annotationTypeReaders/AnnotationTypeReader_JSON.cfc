<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" extends="BaseAnnotationTypeReader" hint="I am a responsible for reading and processing a JSON annotation.">

	<cffunction name="isThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		<cfargument name="annotationValue" type="string" required="true" />
		
		<cfif isJSON(arguments.annotationValue)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>

	<cffunction name="getRules" returnType="array" access="public" output="false" hint="I take the annotationValue and process it into rules">
		<cfargument name="annotationValue" type="string" required="true" />

		<cfset var rules = deserializeJSON(arguments.annotationValue) />
		<cfif isArray(rules)>
			<cfreturn rules />
		<cfelse>
			<cfthrow type="ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_JSON.invalidJSON" detail="The json object in the annotation (#arguments.annotationValue#) does not contain an array of rules." />
		</cfif>

	</cffunction>
		
</cfcomponent>
	

