component extends="approot.test.BaseTestCase"
{	
	
	function testIndex()
	{
		var event = "";
		var rc = "";
		
		// Execute Event
		event = execute( "general.index" );
		rc = event.getCollection();
		
		// assert
		assertTrue( isArray( rc.users ) );
	}
	
}
