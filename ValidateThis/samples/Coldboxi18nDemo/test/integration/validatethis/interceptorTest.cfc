component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
		validatethis = instance.controller.getColdboxOCM().get( "validatethis" );
	}

	function testVTIsInCache()
	{
		// assert
		assertTrue( IsObject( validatethis ) );
		assertTrue( IsInstanceOf( validatethis, "validatethis.validatethis" ) );
	}
	
	function testVTConfig()
	{
		var validatethisconfig = validatethis.getValidateThisConfig();
		// assert
		assertTrue( IsStruct( validatethisconfig ) );
		assertFalse( validatethisconfig.JSIncludes );
		assertEquals( validatethisconfig.ResultPath, "model.ValidationResult" );
		assertEquals( validatethisconfig.boValidatorPath, "model.BOValidator" );
		assertEquals( validatethisconfig.translatorPath, "ValidateThis.extras.coldbox.ColdBoxRBTranslator" );
		assertEquals( validatethisconfig.debuggingMode, "none" );
		
		debug( validatethisconfig );
	}

}
