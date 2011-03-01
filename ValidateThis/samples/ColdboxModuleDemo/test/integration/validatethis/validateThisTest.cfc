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
		assertEquals( "model.ValidationResult", validatethisconfig.ResultPath );
		assertEquals( "model.BOValidator", validatethisconfig.boValidatorPath );
		
		debug( validatethisconfig );
	}
	
	function testVTUsingCustomResult()
	{
		var result = validatethis.newResult();
		// assert
		assertEquals( "model.ValidationResult", GetMetaData( result ).name );
	}
	
	function testVTUsingCustomBOValidator()
	{
		var result = validatethis.getValidator( objectType='user' );
		// assert
		assertEquals( "model.BOValidator", GetMetaData( result ).name );
	}
		
}
