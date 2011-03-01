component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
		instance.validatethis = instance.controller.getColdboxOCM().get( "validatethis" );
	}

	function testVTIsInCache()
	{
		// assert
		assertTrue( IsObject( instance.validatethis ) );
		assertTrue( IsInstanceOf( instance.validatethis, "validatethis.validatethis" ) );
	}
		
	function testVTConfig()
	{
		var validatethisconfig = instance.validatethis.getValidateThisConfig();
		// assert
		assertTrue( IsStruct( validatethisconfig ) );
		assertFalse( validatethisconfig.JSIncludes );
		assertEquals( "model.ValidationResult", validatethisconfig.ResultPath );
		assertEquals( "model.BOValidator", validatethisconfig.boValidatorPath );
		assertEquals( "info", validatethisconfig.debuggingMode );
		
		debug( validatethisconfig );
	}
	
}
