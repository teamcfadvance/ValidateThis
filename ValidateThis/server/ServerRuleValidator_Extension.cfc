component
	output="false"
	name="ServerRuleValidator_Extension"
	extends="AbstractServerRuleValidator"
	hint="I am responsible for performing the Extension validation."
{

	public any function validate(
		required any validation hint="The validation object created by the business object being validated.",
		required string locale hint="The locale to use to generate the default failure message."
	)
		hint = "I perform the validation returning info in the validation object."
	{
		var parameters = arguments.validation.getParameters();
		var theValue = arguments.validation.getObjectValue();
		var args = [arguments.validation.getPropertyDesc()];
		
		if ( !structKeyExists(parameters, "extension") ) {
			throw(
				type="validatethis.server.ServerRuleValidator_Extension.missingParameter",
				message="An extension parameter must be defined for an extension rule type."
			);
		}
		
		var isValid = true;
		if ( len(trim(theValue)) > 0 ) {
			var formFieldName = validation.getClientFieldName();
			var fileName = getUploadFileName(formFieldName);
			var fileExtension = getFileExtension(fileName);
			var validFileExtensions = parameters.extension;
			
			isValid = listFind(
				validFileExtensions,
				fileExtension,
				"|"
			);
		}
		
		if ( shouldTest(arguments.validation) AND !isValid ) {
			fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_Extension",args,arguments.locale));
		}
	}

	private string function getFileExtension(
		required string fileName hint="File name from which to get an extension."
	) 
		hint="Gets file extension from a file name."
	{
		if(find(".",fileName)) return listLast(fileName,".");
		else return "";
	}
	
	private string function getUploadFileName(
		required string formFieldName hint="Field name from which to get a file name."
	)
		hint="Gets the file name of an upload file."
	{
		if ( listFindNoCase("railo,lucee", server.coldfusion.productname) ) {
			return getUploadFileNameLucee(formFieldName);
		} else {
			return getUploadFileNameACF(formFieldName);
		}
	}
	
	private string function getUploadFileNameLucee(
		required string formFieldName hint="Field name from which to get a file name."
	)
		hint="Gets the file name of an upload file. (Lucee version.)"
	{
		return getPageContext().formScope().getUploadResource(formFieldName).getName();
	}
	
	// FIXME: untested (i don't have acf handy)
	private string function getUploadFileNameACF(
		required string formFieldName hint="Field name from which to get a file name."
	)
		hint="Gets the file name of an upload file. (Adobe ColdFusion version.)"
	{
		var fileName = "";
		var parts = form.getPartsArray();
		if ( isDefined("parts") ) {
			for ( var part in parts ) {
				if ( part.isFile() and part.getName() eq formFieldName ) {
					fileName = part.getFileName();
				}
			}
		}
		return fileName;
	}

}