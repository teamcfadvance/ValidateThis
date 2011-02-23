SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';


DROP TABLE IF EXISTS tblUserGroup;

CREATE TABLE tblUserGroup (
	UserGroupId int NOT NULL AUTO_INCREMENT,
	UserGroupDesc varchar(100) NOT NULL,
	PRIMARY KEY (UserGroupId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tblUser;

CREATE TABLE tblUser (
	UserId int NOT NULL AUTO_INCREMENT,
	UserGroupId int NOT NULL DEFAULT 1,
	UserName varchar(100) NOT NULL,
	UserPass varchar(50) NOT NULL DEFAULT '',
	Nickname varchar(50) NOT NULL,
	Salutation varchar(10) NULL,
	FirstName varchar(50) NULL,
	LastName varchar(50) NULL,
	LikeCheese bit NULL,
	LikeChocolate bit NULL,
	LikeOther varchar(100) NULL,
	AllowCommunication bit NULL,
	CommunicationMethod varchar(100) NULL,
	HowMuch decimal(18,2) NULL,
	HowCool decimal(18,2) NULL,
	LastUpdateTimestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (UserId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO tblUserGroup
           (UserGroupDesc)
     VALUES ('Member');

INSERT INTO tblUserGroup
           (UserGroupDesc)
     VALUES ('Administrator');

INSERT INTO tblUser
           (UserGroupId, UserName ,UserPass, Nickname, Salutation, FirstName, LastName, LikeCheese, LikeChocolate, LikeOther, AllowCommunication, CommunicationMethod, HowMuch)
     VALUES (1, 'BobS', 'MyPassWord', 'Bobby', 'Mr.', 'Bob', 'Silverberg', 1, 1, 'Cake', 1, 'Email', 1000000);
     
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;