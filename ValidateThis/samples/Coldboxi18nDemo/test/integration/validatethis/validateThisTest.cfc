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
	
	function testFailureMessageIsDefaultLocaleWhenNoLocalePassed()
	{
		var FileUtils = getPlugin( "fileUtils" );
		var user = EntityNew( "User" );
		var rbpath = FileUtils.getAbsolutePath( "../includes/i18n/main_en_GB.properties" );
		var rbmessage = GetProfileString( rbpath, "validation", "VerifyPasswordRequired" );
		var vtresult = validatethis.validate( User );
		var failurestruct = vtresult.getFailureMessagesByProperty();
		debug( failurestruct );
		var failuremessage = failurestruct.VerifyPassword[ 1 ];
		//assert
		assertTrue( failuremessage == rbmessage, "expected '#rbmessage#', got '#failuremessage#'" );
	}
	
	function testFailureMessageIsFrenchWhenFrenchLocalePassed()
	{
		// assert
		var FileUtils = getPlugin( "fileUtils" );
		var user = EntityNew( "User" );
		var rbpath = FileUtils.getAbsolutePath( "../includes/i18n/main_fr_FR.properties" );
		var rbmessage = GetProfileString( rbpath, "validation", "VerifyPasswordRequired" );
		var vtresult = validatethis.validate( User );
		var failuremessage = vtresult.getFailureMessagesByProperty( locale="fr_FR" ).VerifyPassword[ 1 ];
		// assert
		
		assertTrue( failuremessage == rbmessage, "expected '#rbmessage#', got '#failuremessage#'" );
	}
	
	function testFailureMessageIsEnglishWhenEnglishLocalePassed()
	{
		// assert
		var FileUtils = getPlugin( "fileUtils" );
		var user = EntityNew( "User" );
		var rbpath = FileUtils.getAbsolutePath( "../includes/i18n/main_en_GB.properties" );
		var rbmessage = GetProfileString( rbpath, "validation", "VerifyPasswordRequired" );
		var vtresult = validatethis.validate( User );
		var failuremessage = vtresult.getFailureMessagesByProperty( locale="en_GB" ).VerifyPassword[ 1 ];
		// assert
		
		assertTrue( failuremessage == rbmessage, "expected '#rbmessage#', got '#failuremessage#'" );
	}
	
}
