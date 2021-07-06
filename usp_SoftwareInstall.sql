CREATE PROCEDURE [dbo].[usp_SoftwareInstall]-- TELNET              
	@software VARCHAR(500)
AS
BEGIN
	DECLARE @SoftwareToInstall TABLE (Id INT IDENTITY, [name] VARCHAR(500))
	DECLARE @dependency VARCHAR(500)
	SET @dependency= @software 
	
	WHILE EXISTS
	(
		SELECT TOP 1 1
		FROM tblDependency
		INNER JOIN tblSoftware S1 ON S1.id= SoftwareId AND  S1.IsInstalled=0
		INNER JOIN tblSoftware S2 ON S2.id= SoftwareDependencyId AND S2.IsInstalled=0
		WHERE s1.name= @dependency
	)
	BEGIN
	    INSERT INTO @SoftwareToInstall
		VALUES (@dependency)
		
		SELECT TOP 1 @dependency=s2.name
		FROM tblDependency
		INNER JOIN tblSoftware S1 ON S1.id= SoftwareId AND  S1.IsInstalled=0
		INNER JOIN tblSoftware S2 ON S2.id= SoftwareDependencyId AND S2.IsInstalled=0
		WHERE s1.name= @dependency
	END
	INSERT INTO @SoftwareToInstall
	VALUES (@dependency)

	MERGE tblSoftware AS TARGET
	USING @SoftwareToInstall AS SOURCE 
	   ON (TARGET.name = SOURCE.name) 
	 WHEN MATCHED THEN 
	   UPDATE SET IsInstalled=1
	 WHEN NOT MATCHED BY TARGET THEN 
	   INSERT (Name,IsInstalled) 
	   VALUES (SOURCE.Name,1);

	SELECT 'Installing '+ [name] AS [Message]
	FROM @SoftwareToInstall
	ORDER BY Id desc
END
