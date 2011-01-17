<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	This is the Application.cfc for usage withing the ColdBox Framework.
	Make sure that it extends the coldbox object:
	coldbox.system.Coldbox
	
	So if you have refactored your framework, make sure it extends coldbox.
----------------------------------------------------------------------->
<cfcomponent output="false">
	<cfsetting enablecfoutputonly="yes">
	<!--- APPLICATION CFC PROPERTIES --->
	<cfscript>
	// Application properties
	this.name = "ValidateThisColdboxDemo";
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;
	
	// ColdBox Specifics
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath());
	COLDBOX_APP_MAPPING = "";
	COLDBOX_CONFIG_FILE = "";
	COLDBOX_APP_KEY = "";
	
	this.mappings["/validatethis"] = ExpandPath( "../../../validatethis/" );
	
	// ORM Setup
	this.ormEnabled = true;
	this.datasource = "VTDemo";
	this.ormSettings = {
		cfclocation = "model",
		dialect = "MySQLwithInnoDB",
		flushAtRequestEnd = false
	};
	</cfscript>
	
	
	<!--- on Application Start --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfscript>
			ORMReload();
			//Load ColdBox
			application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			application.cbBootstrap.loadColdbox();
			return true;
		</cfscript>
	</cffunction>
	
	<!--- on Request Start --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<!--- ************************************************************* --->
		<cfargument name="targetPage" type="string" required="true" />
		<!--- ************************************************************* --->
		<!--- BootStrap Reinit Check --->
		<cfif not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit()>
			<cflock name="coldbox.bootstrap_#hash(getCurrentTemplatePath())#" type="exclusive" timeout="5" throwontimeout="true">
				<cfset ORMReload()>
				<cfset structDelete(application,"cbBootStrap")>
				<cfset application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING)>
			</cflock>
		</cfif>
		<!--- Reload Checks --->
		<cfset application.cbBootstrap.reloadChecks()>
		
		<!--- Process A ColdBox Request Only --->
		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>
			<cfset application.cbBootstrap.processColdBoxRequest()>
		</cfif>
			
		<!--- WHATEVER YOU WANT BELOW --->
		<cfreturn true>
	</cffunction>
	
	<!--- on Application End --->
	<cffunction name="onApplicationEnd" returnType="void"  output="false">
		<!--- ************************************************************* --->
		<cfargument name="appScope" type="struct" required="true">
		<!--- ************************************************************* --->
		<cfset arguments.appScope.cbBootstrap.onApplicationEnd(argumentCollection=arguments)>
	</cffunction>
	
	<!--- on Session Start --->
	<cffunction name="onSessionStart" returnType="void" output="false">			
		<cfset application.cbBootstrap.onSessionStart()>
	</cffunction>
	
	<!--- on Session End --->
	<cffunction name="onSessionEnd" returnType="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" 	type="struct" required="false">
		<!--- ************************************************************* --->
		<cfset appScope.cbBootstrap.onSessionEnd(argumentCollection=arguments)>
	</cffunction>
	
	<!--- OnMissing Template --->
	<cffunction	name="onMissingTemplate" access="public" returntype="boolean" output="true" hint="I execute when a non-existing CFM page was requested.">
		<cfargument name="template"	type="string" required="true"	hint="I am the template that the user requested."/>
		<cfreturn application.cbBootstrap.onMissingTemplate(argumentCollection=arguments)>
	</cffunction>
	
</cfcomponent>