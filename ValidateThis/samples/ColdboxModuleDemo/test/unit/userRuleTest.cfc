component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
	}

	function testIsXML()
	{
		var FileUtils = getPlugin( "fileUtils" );
		var file = FileUtils.readFile( FileUtils.getAbsolutePath( "../model/User.xml.cfm" ) );
		
		// assert
		assertTrue( IsXML( file ) );
	}

	function testValidatesAgainstSchema()
	{
		var FileUtils = getPlugin( "fileUtils" );
		var file = FileUtils.readFile( FileUtils.getAbsolutePath( "../model/User.xml.cfm" ) );
		var xmlValidateResult = XMLValidate( file, FileUtils.getAbsolutePath( "/validatethis/core/validateThis.xsd" ) );
		// assert
		assertTrue( xmlValidateResult.status );
	}	
}
