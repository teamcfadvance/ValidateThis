component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
		validatethis = instance.controller.getColdboxOCM().get( "validatethis" );
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
	
	function testVTDefaultLocaleIsColdBoxDefaultLocale()
	{
		var validatethisconfig = validatethis.getValidateThisConfig();
		// assert
		assertEquals( getPlugin( "i18n" ).getfwLocale(), validatethisconfig.defaultLocale );
	}

	function testVTUsingColdBoxRTTranslator()
	{
		// assert
		assertTrue( IsInstanceOf( validatethis.getBean( "translator" ), "ValidateThis.extras.coldbox.ColdBoxRBTranslator" ) );
	}
	
	function testgetRawFailures()
	{
		var user = EntityNew( "User" );
		var vtresult = validatethis.validate( User );
		var rawfailures = vtresult.getRawFailures();
		
		assertTrue( IsArray( rawfailures ) );
		assertTrue( ArrayLen( rawfailures ) == 8 );
		
		debug( rawfailures );
	}
}
