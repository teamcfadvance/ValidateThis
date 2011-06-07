component extends="cfselenium.CFSeleniumTestCase" displayName="EndToEnd-Server" {

    public void function beforeTests() {
        browserUrl = "http://localhost/validatethis/samples/FacadeDemo/";
        super.beforeTests();
        selenium.setTimeout(30000);
        crlf = chr(10);
    }

    public void function testEndToEndServer() {
        selenium.open("http://localhost/validatethis/samples/FacadeDemo/index.cfm?init=true&noJS=true");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The Email Address is required.#crlf#Hey, buddy, you call that an Email Address?",selenium.getText("error-UserName"));
        assertEquals("The Password is required.#crlf#The Password must be between 5 and 10 characters long.#crlf#The password must be between 5 and 10 characters long (expression).", selenium.getText("error-UserPass"));
        assertEquals("The Verify Password is required.", selenium.getText("error-VerifyPassword"));
        assertEquals("The User Group is required.", selenium.getText("error-UserGroupId"));
        assertEquals("If you don't like Cheese and you don't like Chocolate, you must like something!", selenium.getText("error-LikeOther"));
        selenium.type("Nickname", "BobRules");
        selenium.type("UserName", "aaa");
        selenium.type("UserPass", "aaa");
        selenium.type("VerifyPassword", "zzz");
        selenium.type("Salutation", "aa");
        selenium.type("FirstName", "aaa");
        selenium.type("HowMuch", "aaa");
        selenium.click("AllowCommunication-1");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("Hey, buddy, you call that an Email Address?",selenium.getText("error-UserName"));
        assertEquals("That Nickname has already been used. Try to be more original!", selenium.getText("error-Nickname"));
        assertEquals("The Password must be between 5 and 10 characters long.#crlf#The password must be between 5 and 10 characters long (expression).", selenium.getText("error-UserPass"));
        assertEquals("The Verify Password must be the same as the Password.", selenium.getText("error-VerifyPassword"));
        assertEquals("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.", selenium.getText("error-Salutation"));
        assertEquals("The How much money would you like? must be a number.",selenium.getText("error-HowMuch"));
        assertEquals("If you are allowing communication, you must choose a communication method.", selenium.getText("error-CommunicationMethod"));
        assertEquals("The Last Name is required if you specify a value for the First Name.", selenium.getText("error-LastName"));
        selenium.type("UserName", "bob.silverberg@gmail.com");
        selenium.type("Nickname", "different");
        selenium.type("UserPass", "aaaaa");
        selenium.type("VerifyPassword", "aaaaa");
        selenium.select("UserGroupId", "label=Member");
        selenium.type("Salutation", "Mr");
        selenium.type("LastName", "aaa");
        selenium.click("LikeCheese-1");
        selenium.type("HowMuch", "999");
        selenium.click("AllowCommunication-2");
        selenium.click("AllowCommunication-1");
        selenium.select("CommunicationMethod", "label=Email");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false,selenium.isElementPresent("error-UserName"));
        assertEquals(false, selenium.isElementPresent("error-Nickname"));
        assertEquals(false, selenium.isElementPresent("error-UserPass"));
        assertEquals(false, selenium.isElementPresent("error-VerifyPassword"));
        assertEquals(false, selenium.isElementPresent("error-UserGroupId"));
        assertEquals(false, selenium.isElementPresent("error-Salutation"));
        assertEquals(false, selenium.isElementPresent("error-LastName"));
        assertEquals(false, selenium.isElementPresent("error-LikeOther"));
        assertEquals(false,selenium.isElementPresent("error-HowMuch"));
        assertEquals(false, selenium.isElementPresent("error-CommunicationMethod"));
        assertEquals("the user has been saved!", selenium.getText("successMessage"));
        selenium.click("link=Edit an Existing User");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("FirstName", "");
        selenium.type("LastName", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The First Name is required.", selenium.getText("error-FirstName"));
        assertEquals("The Last Name is required.", selenium.getText("error-LastName"));
        selenium.type("FirstName", "bob");
        selenium.type("LastName", "bob");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false, selenium.isElementPresent("error-FirstName"));
        assertEquals(false, selenium.isElementPresent("error-LastName"));
        selenium.type("UserPass", "aaa");
    }
}
