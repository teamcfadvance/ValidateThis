<cfcomponent output="false">

<cfscript>
    // Mappings Imports
    this.mappings["/VTDemo"] = getDirectoryFromPath(getCurrentTemplatePath());
    this.mappings["/BODemo"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/BODemo";
    this.mappings["/AnnotationDemo"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/AnnotationDemo";
    this.mappings["/ServiceDemo"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/ServiceDemo";
    this.mappings["/models"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/models";
    this.mappings["/UnitTests"] = getDirectoryFromPath(getCurrentTemplatePath()) & "/UnitTests";
</cfscript>

</cfcomponent>