CREATE PROCEDURE [dbo].[usp_SoftwareList]
AS
	SELECT name AS [Message]
	FROM tblSoftware
	WHERE IsInstalled =1
