component 
{
	// Dependancy Injection
	property name="SessionStorage" inject="coldbox:plugin:SessionStorage";

	/**
	 * I run on every request
	 */
	void function requeststart( required event )
	{
		var rc = arguments.event.getCollection();
		
		// flag to indicate whether to use client side validation
		if ( StructKeyExists( rc, "nojs" ) )
		{
			variables.SessionStorage.setVar( "nojs", rc.nojs );
		}
		else
		{
			rc.nojs = variables.SessionStorage.getVar( "nojs", false );
		}
		
	}

}