if exists (select * from dbo.sysobjects where id = object_id(N'[tblUserGroup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [tblUserGroup];

if exists (select * from dbo.sysobjects where id = object_id(N'[tblUser]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [tblUser];
GO

CREATE TABLE dbo.tblUserGroup (
	[UserGroupId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[UserGroupDesc] [varchar](100) NOT NULL
)

CREATE TABLE dbo.tblUser (
	[UserId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[UserGroupId] [int] NOT NULL DEFAULT (1),
	[UserName] [varchar](100) NOT NULL,
	[UserPass] [varchar](50) NOT NULL DEFAULT (''),
	[Nickname] [varchar](50) NOT NULL,
	[Salutation] [varchar](10) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[LikeCheese] [bit] NULL,
	[LikeChocolate] [bit] NULL,
	[LikeOther] [varchar](100) NULL,
	[AllowCommunication] [bit] NULL,
	[CommunicationMethod] [varchar](100) NULL,
	[HowMuch] [decimal](18,2) NULL,
	[HowCool] [decimal](18,2) NULL,
	[LastUpdateTimestamp] [datetime] NOT NULL DEFAULT (getdate())
)

INSERT INTO dbo.tblUserGroup
           (UserGroupDesc)
     VALUES ('Member');

INSERT INTO dbo.tblUserGroup
           (UserGroupDesc)
     VALUES ('Administrator');

INSERT INTO dbo.tblUser
           (UserGroupId, UserName ,UserPass, Nickname, Salutation, FirstName, LastName, LikeCheese, LikeChocolate, LikeOther, AllowCommunication, CommunicationMethod, HowMuch)
     VALUES (1, 'BobS', 'MyPassWord', 'Bobby', 'Mr.', 'Bob', 'Silverberg', 1, 1, 'Cake', 1, 'Email', 1000000)

GO