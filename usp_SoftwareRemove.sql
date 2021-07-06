CREATE PROCEDURE [dbo].[usp_SoftwareRemove]
	@software VARCHAR(500)
AS
BEGIN
    IF (
		SELECT COUNT(*)
		FROM tblDependency
		INNER JOIN tblSoftware S1 ON S1.id= SoftwareId AND  S1.IsInstalled=1
		INNER JOIN tblSoftware S2 ON S2.id= SoftwareDependencyId AND S2.IsInstalled=1
		WHERE s2.name= @software
		)>1				
		BEGIN
			SELECT @software+ ' is still needed ' AS [Message]		    
		END
	ELSE
	BEGIN
		DECLARE @SoftwareToRemove TABLE (Id INT IDENTITY, [name] VARCHAR(500))
		DECLARE @dependency VARCHAR(500)
		SET @dependency= @software 
		WHILE EXISTS
		(
			SELECT TOP 1 1
			FROM tblDependency
			INNER JOIN tblSoftware S1 ON S1.id= SoftwareId AND  S1.IsInstalled=1
			INNER JOIN tblSoftware S2 ON S2.id= SoftwareDependencyId AND S2.IsInstalled=1
			WHERE s2.name= @dependency
		)
		BEGIN
			INSERT INTO @SoftwareToRemove
			VALUES (@dependency)
		
			SELECT TOP 1 @dependency=s1.name
			FROM tblDependency
			INNER JOIN tblSoftware S1 ON S1.id= SoftwareId AND  S1.IsInstalled=1
			INNER JOIN tblSoftware S2 ON S2.id= SoftwareDependencyId AND S2.IsInstalled=1
			WHERE s2.name= @dependency
		END
		INSERT INTO @SoftwareToRemove
		VALUES (@dependency)

		UPDATE s 
		SET IsInstalled=0
		FROM tblSoftware s
		INNER JOIN @SoftwareToRemove t ON t.name = s.name
		
		SELECT 'Removing '+ [name] AS [Message]
		FROM @SoftwareToRemove
		ORDER BY Id desc
	    
	END		

END