CREATE PROCEDURE [dbo].[usp_DependecyAdd] --TELNET TCPIP NETCARD, TCPIP NETCARD

	@list VARCHAR(500)
AS
BEGIN
	DECLARE @tblDependecyList TABLE (ID INT IDENTITY, dependency VARCHAR(500))
	INSERT INTO @tblDependecyList	
	SELECT VALUE
	FROM STRING_SPLIT(@list, ' ')

	INSERT INTO tblSoftware(name, IsInstalled)
	SELECT DISTINCT REPLACE(dependency ,',',''), 0 
	FROM @tblDependecyList

	WHILE EXISTS(SELECT TOP 1 1 FROM @tblDependecyList )
	BEGIN
		;WITH cte AS(
			SELECT TOP 2 ROW_NUMBER() RN, dependency
			FROM @tblDependecyList
			ORDER BY ID
			)	
		INSERT INTO tblDependency (SoftwareId, SoftwareDependencyId)
		SELECT S1.ID, S2.ID
		FROM cte 
		INNER JOIN tblSoftware S1 ON S1.name = cte.dependency AND cte.rn=1
		INNER JOIN tblSoftware S2 ON S2.name = cte.dependency AND cte.rn=2
		WHERE rn <3 

		DELETE TOP(1) FROM @tblDependecyList
		IF(CHARINDEX(',',(SELECT TOP 1 dependency FROM @tblDependecyList ORDER BY ID))>0) 
			DELETE TOP(1) FROM @tblDependecyList
	END
	
	SELECT 'DEPEND '+VALUE AS [Message]
	FROM STRING_SPLIT(@list, ',')
END


