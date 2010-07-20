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
<cfcomponent output="false" extends="ValidateThis.core.BaseMetadataProcessor" hint="I am a responsible for reading and processing an annotation.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new XMLFileReader">
		<cfargument name="defaultFormName" type="string" required="true" />

		<cfset super.init(argumentCollection=arguments) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="annotationsAreThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		
		<cfargument name="properties" type="array" required="true" />
		
		<cfloop array="#arguments.properties#" index="prop">
			<cfif structKeyExists(prop,"vtRules") and isThisFormat(prop.vtRules)>
				<cfreturn true />
			</cfif>
		</cfloop>
		<cfreturn false />

	</cffunction>

	<cffunction name="normalizeValidations" returnType="struct" access="private" output="false" hint="I take the rules and post-process them using other property metadata">
		<cfargument name="allRules" type="struct" required="true" />
		
		<cfreturn arguments.allRules />
	</cffunction>

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I take the metadata and reformat it into a struct">
		<cfargument name="metadataSource" type="any" required="true" hint="the object metadata" />
		
		<cfthrow type="ValidateThis.core.fileReaders.BaseFileReader.MissingImplementation" detail="The loadRules method must be implemented in a concrete AnnotationTypeReader object" />

	</cffunction>

	<cffunction name="isThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		<cfargument name="annotationValue" type="string" required="true" />
		
		<cfthrow type="ValidateThis.core.annotationTypeReaders.BaseAnnotationTypeReader.MissingImplementation" detail="The isThisFormat method must be implemented in a concrete AnnotationTypeReader object" />
		
	</cffunction>

</cfcomponent>
