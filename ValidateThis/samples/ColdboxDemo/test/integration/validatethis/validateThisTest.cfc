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
		assertTrue( validatethisconfig.ResultPath == "model.ValidationResult" );
		assertTrue( validatethisconfig.boValidatorPath == "model.BOValidator" );
		
		debug( validatethisconfig );
	}
	
	function testVTUsingCustomResult()
	{
		var result = validatethis.newResult();
		// assert
		assertTrue( IsInstanceOf( result, "model.ValidationResult" ) );
	}
	
	function testVTUsingCustomBOValidator()
	{
		var result = validatethis.getValidator( objectType='user' );
		// assert
		assertTrue( IsInstanceOf( result, "model.BOValidator" ) );
	}
		
}
