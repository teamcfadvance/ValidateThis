INSERT INTO tblUserGroup_A
           (UserGroupDesc)
     VALUES ('Member');

INSERT INTO tblUserGroup_A
           (UserGroupDesc)
     VALUES ('Administrator');

INSERT INTO tblUser_A
           (UserGroupId, UserName ,UserPass, Nickname, Salutation, FirstName, LastName, LikeCheese, LikeChocolate, LikeOther, AllowCommunication, CommunicationMethod, HowMuch)
     VALUES (1, 'BobS', 'MyPassWord', 'Bobby', 'Mr.', 'Bob', 'Silverberg', 1, 1, 'Cake', 1, 'Email', 1000000);
