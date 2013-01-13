USE master;
GO
CREATE DATABASE slccasenex
GO
USE slccasenex;
GO
CREATE TABLE [slccasenex].[dbo].messages
(
	"MessageID" INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	"Subject" nvarchar(max) NOT NULL,
	"Body" nvarchar(max) NOT NULL,
	"Filters" nvarchar(max) NOT NULL
)
GO


CREATE TABLE [slccasenex].[dbo].recipienttypes
(
	"RecipientType" INT PRIMARY KEY NOT NULL,
	"Name" varchar(50) NOT NULL
)
GO
CREATE TABLE [slccasenex].[dbo].messagerecipients
(
	"MessageID" INT NOT NULL FOREIGN KEY REFERENCES messages(MessageID),
	"Sender" varchar(200) NOT NULL,
	"Recipient" varchar(200) NOT NULL,
	"RecipientType" INT NOT NULL FOREIGN KEY REFERENCES recipienttypes(RecipientType)
)
GO

ALTER TABLE messagerecipients ADD CONSTRAINT pk PRIMARY KEY (MessageID, Sender, Recipient, RecipientType)
GO

USE slccasenex;
GO
INSERT INTO recipienttypes VALUES (1, 'Student');
INSERT INTO recipienttypes VALUES (2, 'Staff');
GO

USE slccasenex;
GO
INSERT INTO recipienttypes VALUES (1, 'Student');
INSERT INTO recipienttypes VALUES (2, 'Staff');
GO