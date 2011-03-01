component extends="coldbox.system.testing.BaseTestCase"
{

	instance.appMapping = ReReplaceNoCase( CGI.SCRIPT_NAME, "/test/(.)+$", "" );
	//instance.appMapping = "/validatethisgithub/ValidateThis/samples/Coldboxi18nDemo";
	
	/**
	* delegate to coldbox getPlugin controller
	*/
	private any function getPlugin( required string pluginname )
	{
		return instance.controller.getPlugin( arguments.pluginname );
	}
}