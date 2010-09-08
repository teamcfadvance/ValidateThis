<!-----------------------------------------------------------------------------------------
	webroot\plugins\scriptInclude.cfc
	CREATED BY AARON GREENLEE 5/19/2009 14:30:30 PM
	---------------------------------------------------------------------------------------
	DESCRIPTION
	The purpose of this file is to provide the ColdBox Framework with the ability to
	control external CSS and JS files as well as internal JS Statements
	on a 'per-request' basis.
	---------------------------------------------------------------------------------------
	AUTHOR: 	Aaron Greenlee
				www.aarongreenlee.com
				aarongreenlee@gmail.com
				Copyright (c) 2009 Aaron Greenlee. All Rights Reserved.
	---------------------------------------------------------------------------------------
	REVISION HISTORY:
	- None
	---------------------------------------------------------------------------------------
	LICSENES
	This software is bounded to the Apache License, Version 2.0.
	--------------------------------------------------------------------------------------->

<cfcomponent name="scriptInclude" extends="coldbox.system.plugin" output="false" cache="false" hint="The scriptInclude plugin helps include CSS and JS files and JavaScript code itself in the HEAD section of a document. Customize 'incluides' path using the custom setting 'scriptIncludeBaseDirectory', 'scriptIncludeSubDirectoryCSS' and 'scriptIncludeSubDirectoryJS' in the 'yourSetting' node of the ColdBox Configuraton File. If choosing to define the custom settings it is important that all three settings be defined." >

	<!------------------------------------------------------------------------------------->
	<!---  Set-Up / Initilize 															--->
	<!------------------------------------------------------------------------------------->

	<cffunction name="init" access="public" hint="Constructor" returntype="scriptInclude">
		<cfargument name="controller" type="any" required="true" />
		<cfscript>
			super.Init(arguments.controller);
			setpluginName("Script Include Plugin");
			setpluginVersion("1.0");
			setpluginDescription("The scriptInclude plugin helps include CSS and JS files and JavaScript code itself in the HEAD section of a document. Customize 'incluides' path using the custom setting 'scriptassetPathBASE', 'scriptIncludeSubDirectoryCSS' and 'scriptIncludeSubDirectoryJS' in the 'yourSetting' node of the ColdBox Configuraton File. If choosing to define the custom settings it is important that all three settings be defined.");
			// CONSTRUCTOR CODE
			variables.instance 					= structNew();
			variables.instance.settings			= structNew();
			// EFFECTS THE ORDER WHEN FETCHING ALL, CSS BEFORE JS
			variables.instance.supports			= "CSS,JS";
			variables.instance.queue			= structNew();
			variables.instance.queue.JS			= arrayNew(1);
			variables.instance.queue.CSS		= arrayNew(1);
			variables.instance.Javascript		= structNew();
			variables.instance.Javascript.HEAD 	= arrayNew(1);
			variables.instance.Javascript.FOOT 	= arrayNew(1);
			variables.instance.Javascript.BODY 	= arrayNew(1);
			// Call Config
			configure();
			// EXIT
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------------------------------------------------->
	<!---  FILE SUPPORT		 															--->
	<!------------------------------------------------------------------------------------->

	<cffunction name="addResource" access="public" returntype="void" output="false" hint="Appends a file to the list of JS or CSS files to include when rendering.">
		<cfargument name="type" type="string" required="true" hint="The type argument defines the resource type that is being added to the resource queue. This value will also be the extension of the file requested. Accepts 'CSS' and 'JS'." />
		<cfargument name="path" type="string" required="true" hint="The URL path to the file." />
		<cfargument name="file" type="string" required="true" hint="The filename to include in the path, without the extention." />
		<cfargument name="prepend" type="boolean" required="false" default="false" hint="The filename to include in the path, without the extention." />
		<cfscript>
			var value = getPath(type=arguments.type,path=arguments.path,file=arguments.file);
			var write = arrayNew(1);
			switch (arguments.type) {
				case 'JS':
					arrayAppend(write, "<script type=""text/javascript"" src=""");
					arrayAppend(write, value);
					arrayAppend(write, """></script>");
				break;
				case 'CSS':
					arrayAppend(write, "<link type=""text/css"" rel=""stylesheet"" href=""");
					arrayAppend(write, value);
					arrayAppend(write, """ />");
				break;
			}
			if (arguments.prepend) {
				arrayPrepend(variables.instance.queue[arguments.type], arrayToList(write,"") );
			} else {
				arrayAppend(variables.instance.queue[arguments.type], arrayToList(write,"") );
			}
		</cfscript>
	</cffunction>

	<cffunction name="getResources" access="public" returntype="string" output="false" hint="Returns the list of files for inclusion in the HEAD section of the page.">
		<cfargument name="type" type="string" required="false" default="all" hint="Defines which set of files to return. Accepts 'CSS', 'JS' and 'ALL'. If blank, defaults to 'ALL'." />
		<cfscript>
			var strLocal 			= structNew();
			strLocal.result			= arrayNew(1);
			strLocal.listAsArray 	= listToArray(variables.instance.supports);

			if ( arguments.type == 'all' ) {
				// LOOP OVER ALL SUPPORTED TYPES
				for( strLocal.i=1; strLocal.i <= arrayLen(strLocal.listAsArray); strLocal.i = strLocal.i+1 ) {
					// SIMPLIFY ACCESS TO RESOURCE
					strLocal.resource = strLocal.listAsArray[strLocal.i];
					arrayAppend(strLocal.result, arrayToList(variables.instance.queue[strLocal.resource], "") );
				}
			} else {
				// CONFIRM TYPE SUPPORTED SUPPORTED
				if (listContainsNoCase( variables.instance.supports, arguments.type, ",") ) {
					arrayAppend(strLocal.result, arrayToList(variables.instance.queue[arguments.type], "") );
				}
			}

			return arrayToList(strLocal.result, "");
		</cfscript>
	</cffunction>

	<!------------------------------------------------------------------------------------->
	<!---  SCRIPT SUPPORT	 															--->
	<!------------------------------------------------------------------------------------->

	<cffunction name="addScript" access="public" returntype="void" output="false" hint="Appends JavaScript to be rendered during this request.">
		<cfargument name="position" type="string" default="head" required="false" hint="Effects the structure the script is loaded into. Accepts 'HEAD', 'FOOTER' and 'BODY'. If blank, defaults to 'HEAD'." />
		<cfargument name="script" type="string" required="true" hint="Valid JavaScript to be included during this request" />
		<cfscript>
			arrayAppend(variables.instance.Javascript[arguments.position], arguments.script);
		</cfscript>
	</cffunction>

	<cffunction name="getScript" access="public" returntype="string" output="false" hint="Appends JavaScript to be rendered during this request.">
		<cfargument name="position" default="head" type="string" required="false" hint="Defines the structure to return. Accepts 'HEAD', 'FOOTER' and 'BODY'. If blank, defaults to 'HEAD'." />
		<cfscript>
			var result = "";
			if ( StructKeyExists(variables.instance.Javascript, arguments.position ) ) {
				arrayPrepend(variables.instance.Javascript[arguments.position], "<script type=""text/javascript"">");
				arrayAppend(variables.instance.Javascript[arguments.position], "</script>");
				result = arrayToList(variables.instance.Javascript[arguments.position], "");
			}
			return result;
		</cfscript>
	</cffunction>

	<!------------------------------------------------------------------------------------->
	<!---  OVERWRITE CONFIGURATION														--->
	<!------------------------------------------------------------------------------------->
	<cffunction name="configure" access="public" returntype="void" output="false" hint="Allows manual configuration of the scriptInclude Plugin. If manually configuring the plug-in, all three arguments are required.">
		<cfargument name="assetPathBASE" type="string" required="false" default="" hint="The directory of your include files relative from your webroot. Example: www.aarongreenlee.com/includes or blank if no directory.">
		<cfargument name="assetPathCSS" type="string" required="false" default="" hint="The relative path from index.cfm containing your CSS assets. Example: 'css' (www.web.com/{assetPathBASE}/css) or 'includes/css' (www.web.com/includes/css) if not defining the baseAssetPath.">
		<cfargument name="assetPathJS" type="string" required="false" default="" hint="The relative path from index.cfm containing your CSS assets. Example: 'css' (www.web.com/{assetPathBASE}/js) or 'includes/js' (www.web.com/includes/js) if not defining the baseAssetPath.">
		<cfscript>

			if ( len(arguments.assetPathBASE) ) {
				variables.instance.settings.assetPathBASE		= arguments.assetPathBASE;
			}
			if ( len(arguments.assetPathCSS) ) {
				variables.instance.settings.assetPathCSS		= arguments.assetPathCSS;
			}
			if ( len(arguments.assetPathJS) ) {
				variables.instance.settings.assetPathJS			= arguments.assetPathJS;
			}

			if ( StructIsEmpty(variables.instance.settings) AND getController().settingExists('scriptassetPathBASE') ) {
				// IF THE BASE DIRECTORY IS DEFINED IN CONFIG, READ INTO MEMORY ALL THREE SETTINGS
				variables.instance.settings.assetPathBASE		= getController().getSetting('assetPathBASE');
				variables.instance.settings.assetPathCSS		= getController().getSetting('assetPathCSS');
				variables.instance.settings.assetPathJS			= getController().getSetting('assetPathJS');
				}

			// NO SETTINGS? SET DEFAULT
			if ( StructIsEmpty(variables.instance.settings) ) {
				variables.instance.settings.assetPathBASE			= "includes";	// Default Root of includes director: 'http://www.yourwebsite.com/includes/
				variables.instance.settings.assetPathJS				= "javascript";	// Default Root of includes director: 'http://www.yourwebsite.com/includes/
				variables.instance.settings.assetPathCSS			= "styles";		// Default Root of includes director: 'http://www.yourwebsite.com/includes/
			}
		</cfscript>
	</cffunction>


	<!------------------------------------------------------------------------------------->
	<!---  PRIVATE																		--->
	<!------------------------------------------------------------------------------------->

	<cffunction name="getPath" access="private" returntype="string" output="false" hint="Builds the path to the requested resource.">
		<cfargument name="type" required="true" hint="The file type. Accepts 'CSS' and 'JS'.">
		<cfargument name="path" required="true" hint="A custom subdirectory of the base include directory.">
		<cfargument name="file" required="true" hint="The name of the file to include without extention.">
		<cfscript>
			var result = arrayNew(1);
			var contentDirectory = "";
			// CONTINUE IF EXTENTION IS FOUND IN SUPPORT LIST
			if (listContainsNoCase( variables.instance.supports, arguments.type, ",") ) {
				// EVALUATE CONTENT DIRECTORY
				if (structKeyExists(variables.instance.settings, "assetPath#arguments.type#")
					AND len( variables.instance.settings["assetPath#arguments.type#"] ) ) {
					// POPULATE CONTENT DIRECTORY
					 contentDirectory = variables.instance.settings["assetPath#arguments.type#"];
				}
				if ( len(variables.instance.settings.assetPathBASE) ) {
					// BASE DIRECTORY
					arrayAppend(result, variables.instance.settings.assetPathBASE);
					arrayAppend(result, "/");
				}

				// RESOURCE DIRECTORY
				if ( len(contentDirectory) ) {
					arrayAppend(result, contentDirectory);
					arrayAppend(result, "/");
				}

				// CUSTOM SUBDIRECTORY
				if ( len(arguments.path) ) {
					arrayAppend(result, arguments.path);
					arrayAppend(result, "/");
				}

				// FILE
				arrayAppend(result, arguments.file);
				arrayAppend(result, ".");
				arrayAppend(result, lcase(arguments.type));
			}
			return arrayToList(result,"");
		</cfscript>
	</cffunction>

</cfcomponent>