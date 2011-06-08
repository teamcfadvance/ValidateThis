component extends="ClientBaseTestCase" displayName="EndToEnd-Client" {

    public void function beforeTests() {
        browserUrl = "http://localhost/validatethis/samples/FacadeDemo/";
        super.beforeTests();
        selenium.setTimeout(30000);
        crlf = chr(10);
    }

    public void function testEndToEndClient() {
        selenium.open("http://localhost/validatethis/samples/FacadeDemo/index.cfm?init=true");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address is required.", selenium.getText(errLocator("UserName")));
        assertEquals("The Password is required.", selenium.getText(errLocator("UserPass")));
        assertEquals("The Verify Password is required.", selenium.getText(errLocator("VerifyPassword")));
        assertEquals("The User Group is required.", selenium.getText(errLocator("UserGroupId")));
        assertEquals("If you don't like Cheese and you don't like Chocolate, you must like something!", selenium.getText(errLocator("LikeOther")));
        selenium.type("Nickname", "BobRules");
        selenium.type("Salutation", "jj");
        selenium.type("FirstName", "bob");
        selenium.type("HowMuch", "a");
        selenium.click("AllowCommunication-1");
        selenium.click("//button[@type='submit']");
        selenium.waitForElementPresent(errLocator("Nickname"));
        assertEquals("That Nickname is already taken. Please try a different Nickname.", selenium.getText(errLocator("Nickname")));
        assertEquals("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.", selenium.getText(errLocator("Salutation")));
        assertEquals("The Last Name is required if you specify a value for the First Name.", selenium.getText(errLocator("LastName")));
        assertEquals("Please enter a valid number.", selenium.getText(errLocator("HowMuch")));
        assertEquals("If you are allowing communication, you must choose a communication method.", selenium.getText(errLocator("CommunicationMethod")));
        selenium.type("UserName", "xxxx");
        selenium.click("//button[@type='submit']");
        assertEquals("Hey, buddy, you call that an Email Address?", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "bob.silverberg@gmail.com");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("UserName")));
        selenium.type("Nickname", "different");
        selenium.typeKeys("Nickname", "different");
        selenium.type("UserPass", "a");
        selenium.typeKeys("UserPass", "a");
        selenium.type("VerifyPassword", "b");
        selenium.typeKeys("VerifyPassword", "b");
        assertEquals("", selenium.getText(errLocator("Nickname")));
        assertEquals("Please enter a value between 5 and 10 characters long.", selenium.getText(errLocator("UserPass")));
        assertEquals("The Verify Password must be the same as The Password.", selenium.getText(errLocator("VerifyPassword")));
        selenium.type("UserPass", "aaaaa");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("UserPass")));
        assertEquals("The Verify Password must be the same as The Password.", selenium.getText(errLocator("VerifyPassword")));
        selenium.type("VerifyPassword", "aaaaa");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("VerifyPassword")));
        selenium.select("UserGroupId", "label=Member");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("UserGroupId")));
        selenium.type("Salutation", "Dr");
        selenium.type("LastName", "bob");
        selenium.click("LikeCheese-1");
        selenium.type("HowMuch", "10");
        selenium.select("CommunicationMethod", "label=Email");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertFalse(selenium.isTextPresent("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed."));
        assertFalse(selenium.isTextPresent("The Last Name is required if you specify a value for the First Name."));
        assertFalse(selenium.isTextPresent("If you don't like Cheese and you don't like Chocolate, you must like something!"));
        assertFalse(selenium.isTextPresent("Please enter a valid number."));
        assertFalse(selenium.isTextPresent("If you are allowing communication, you must choose a communication method."));
        selenium.click("link=Edit an Existing User");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false,selenium.isElementPresent(errLocator("FirstName")));
        assertEquals(false,selenium.isElementPresent(errLocator("LastName")));
        selenium.type("FirstName", "");
        selenium.type("LastName", "");
        selenium.click("//button[@type='submit']");
        assertEquals("The First Name is required.", selenium.getText(errLocator("FirstName")));
        assertEquals("The Last Name is required.", selenium.getText(errLocator("LastName")));
        selenium.type("FirstName", "a");
        selenium.typeKeys("FirstName", "a");
        selenium.type("LastName", "a");
        selenium.typeKeys("LastName", "a");
        assertNotEquals("This field is required.", selenium.getText(errLocator("FirstName")));
        assertNotEquals("This field is required.", selenium.getText(errLocator("LastName")));
    }
    
}
