<!--- 
   Copyright 2007 Paul Marcotte, Bob Silverberg

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   TransientFactory.cfc (.1)
   [2009-09-25]	Initial Release.				
 --->
<cfcomponent displayname="TransientFactory" output="false" hint="I create Transient objects.">

	<!--- public --->

	<cffunction name="init" access="public" output="false" returntype="any" hint="returns a configured transient factory">
		<cfargument name="classes" type="struct" required="false" default="#StructNew()#">
		<cfargument name="afterCreateMethod" type="string" required="false" default="">
		<cfset variables.classes = arguments.classes>
		<cfset variables.afterCreateMethod = arguments.afterCreateMethod>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="any" hint="returns a configured, autowired transient">
		<cfargument name="transientName" type="string" required="true">
		<cfargument name="initArgs" type="struct" required="false" default="#structNew()#">
		<cfset var local = {} />
		<cfset local.obj = createObject("component",getTFClassPath(arguments.transientName))>
		<cfif StructKeyExists(local.obj,"init")>
			<cfset getOnMMHelper().doInvoke("init",arguments.initArgs,local.obj) />
		</cfif>
		<cfset getBeanInjector().autowire(targetComponent=local.obj, targetComponentTypeName=arguments.transientName) />
		<cfif StructKeyExists(local.obj,variables.afterCreateMethod)>
			<cfinvoke component="#local.obj#" method="#variables.afterCreateMethod#" />
		</cfif>
		<cfreturn local.obj>
	</cffunction>

	<cffunction name="getClasses" access="public" output="false" returntype="struct" hint="returns map of classes that can be created.">
		<cfreturn variables.classes>
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="any" hint="provides virtual api [new{transientName}] for any registered transient.">
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="struct" required="true" />
		<cfif (Left(arguments.MissingMethodName,3) eq "new")>
			<cfreturn create(Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-3),arguments.MissingMethodArguments)>
		</cfif>
	</cffunction>

	<!--- private --->
	
	<!--- TODO: Had to be changed for Railo --->
	<cffunction name="getTFClassPath" access="private" output="false" returntype="string" hint="returns the transient class path.">
		<cfargument name="transientName" type="string" required="true">
		<cfreturn variables.classes[arguments.transientName]>
	</cffunction>

	<!--- dependencies --->

	<cffunction name="setBeanInjector" access="public" returntype="void" output="false">
		<cfargument name="BeanInjector" type="any" required="true">
		<cfset variables.BeanInjector = arguments.BeanInjector >
	</cffunction>
	
	<cffunction name="getBeanInjector" access="public" returntype="any" output="false">
		<cfreturn variables.BeanInjector />
	</cffunction>

	<cffunction name="setonMMHelper" access="public" returntype="void" output="false">
		<cfargument name="onMMHelper" type="any" required="true">
		<cfset variables.onMMHelper = arguments.onMMHelper >
	</cffunction>
	
	<cffunction name="getonMMHelper" access="public" returntype="any" output="false">
		<cfreturn variables.onMMHelper />
	</cffunction>

</cfcomponent>
