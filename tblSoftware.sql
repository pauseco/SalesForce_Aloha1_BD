CREATE TABLE [dbo].[tblSoftware]
(
	[Id] INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(500),
	[IsInstalled] BIT DEFAULT 0
)
