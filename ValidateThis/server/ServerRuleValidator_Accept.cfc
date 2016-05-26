component
	output="false"
	name="ServerRuleValidator_Accept"
	extends="AbstractServerRuleValidator"
	hint="I am responsible for performing the Accept validation."
{

	public any function validate (
		required any validation hint="The validation object created by the business object being validated.",
		required string locale hint="The locale to use to generate the default failure message."
	)
		hint = "I perform the validation returning info in the validation object."
	{
		var parameters = arguments.validation.getParameters();
		var theValue = arguments.validation.getObjectValue();
		var args = [arguments.validation.getPropertyDesc()];
		
		if ( !structKeyExists(parameters, "accept") ) {
			throw(
				type="validatethis.server.ServerRuleValidator_Accept.missingParameter",
				message="An accept parameter must be defined for an accept rule type."
			);
		}
		
		var isValid = true;
		if ( len(trim(theValue)) > 0 ) {
			var formFieldName = validation.getClientFieldName();
			
			if ( listFindNoCase("railo,lucee", server.coldfusion.productname) ) {
				var fileMimeType = getUploadMimeTypeLucee(formFieldname);
			} else {
				// FIXME: untested (i don't have acf handy)
				var fileName = getUploadFileName(formFieldName);
				var fileMimeType = getFileMimeTypeACF(fileName);
			}
			
			var validMimeTypes = parameters.accept;
			
			isValid = listFind(
				validMimeTypes,
				fileMimeType,
				"|"
			);
		}
		
		if ( shouldTest(arguments.validation) AND !isValid ) {
			fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_Accept",args,arguments.locale));
		}
	}
	
	private string function getUploadMimeTypeLucee(
		required string formFieldName hint="Upload field name from which to get mime type."
	)
		hint="Gets the mime (a.k.a., 'content') type of an upload file. (Lucee version.)"
	{
		return getPageContext().formScope().getUploadResource(formFieldName).getContentType();
	}
	
	// FIXME: untested (i don't have acf handy)
	/* TODO: this method probably isn't as robust as getUploadMimeTypeLucee,
	* since that one gets its mime type from the browser, the same way that
	* fileUpload() does. This is just some static method that checks file names,
	* but its probably not as complete (or guaranteed to match) the browser's.
	*/
	private string function getFileMimeTypeACF(
		required string fileName hint="File name from which to get mime type.."
	)
		hint="Gets the mime (a.k.a., 'content') type from a file name. (Adobe ColdFusion version.)"
	{
		return getPageContext().getServletContext().getMimeType(fileName);
	}

}