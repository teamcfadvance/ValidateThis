component extends="cfselenium.CFSeleniumTestCase" displayName="EndToEnd-Client" {

    private string function errLocator(name) {
    	return "css=p.errorField[htmlfor=#arguments.name#]";
    }

}
