--https://www.sqlshack.com/using-dynamic-data-masking-in-sql-server-2016-to-protect-sensitive-data/
truncate table dbo.Amir_stam

EXEC sp_rename 'dbo.Amir_Toad_Daignosis_Year_Gr+Masked_Age_Gr_1', 'Amir_stam1'; 

SELECT CURRENT_USER; 

--EXECUTE AS USER = 'sys';
EXECUTE AS USER = 'BRIUTNT\amir.shaked';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE') 


--CREATE USER DDMUser WITHOUT LOGIN;  
GRANT SELECT ON dbo.Amir_stam1 TO 'BRIUTNT\amir.shaked';

EXECUTE AS USER = 'BRIUTNT\amir.shaked';  
SELECT * FROM dbo.Amir_stam1;  
REVERT;

ALTER TABLE dbo.Amir_stam1  
ALTER COLUMN Cancer_Type nvarchar(50) MASKED WITH (FUNCTION = 'default()');
--++++++++++++++++++++++++++++++++++++++++++
--Try to grant permissions to run a stored prcedure - failed
USE Health_DWH;   
GRANT EXECUTE ON OBJECT::dbo.Amir_Test1  
    TO amir.shaked;  
GO 

--Stored procdure example - should return the first 2 letters of the input parametr if we call the S.P using:
EXECUTE dbo.Amir_Test1  @SSN_IN_1 = 'Amir', @SSN_IN_2 = 'Shaked', @SSN_OUT = null; --failed

--...Creating this SP
USE Health_DWH
GO
CREATE PROCEDURE dbo.Amir_Test1 
      -- Add the parameters for the stored procedure here
      @SSN_IN_1 varchar(9), 
      @SSN_IN_2 varchar(9),
      @SSN_OUT varchar(50) OUTPUT
      AS
      DECLARE
             @In1 char(1)
            ,@In2 char(1)
            
      SET @In1 =  SUBSTRING(@SSN_IN_1,1,1)
      SET @In2 =  SUBSTRING(@SSN_IN_2,1,1)
      --For input Amir Shaked, expected result is AS
      
      SET @SSN_OUT = @In1 + @In2 
      PRINT @SSN_OUT

--++++++++++++++++++++++++++++++++++++++++++
--Masking example
--Cretaing the Masking settings table
-- Drop ##Tips Masking Table before re-creating it
USE Health_DWH
GO
IF OBJECT_ID('Amir_Masking_Table') IS NOT  NULL
      DROP TABLE dbo.Amir_Masking_Table
CREATE TABLE Amir_Masking_Table (
PositionNumber int NOT  NULL,
OriginalText char(1) NOT NULL,
MaskText char(1)
)
 
-- Insert rows into the masking table
INSERT INTO Amir_Masking_Table  VALUES(1,'0','8')
INSERT INTO Amir_Masking_Table  VALUES(1,'1','7')
INSERT INTO Amir_Masking_Table  VALUES(1,'2','6')
INSERT INTO Amir_Masking_Table  VALUES(1,'3','5')
INSERT INTO Amir_Masking_Table  VALUES(1,'4','4')
INSERT INTO Amir_Masking_Table  VALUES(1,'5','3')
INSERT INTO Amir_Masking_Table  VALUES(1,'6','2')
INSERT INTO Amir_Masking_Table  VALUES(1,'7','1')
INSERT INTO Amir_Masking_Table  VALUES(1,'8','0')
INSERT INTO Amir_Masking_Table  VALUES(1,'9','9')
INSERT INTO Amir_Masking_Table  VALUES(2,'0','9')
INSERT INTO Amir_Masking_Table  VALUES(2,'1','0')
INSERT INTO Amir_Masking_Table  VALUES(2,'2','2')
INSERT INTO Amir_Masking_Table  VALUES(2,'3','6')
INSERT INTO Amir_Masking_Table  VALUES(2,'4','4')
INSERT INTO Amir_Masking_Table  VALUES(2,'5','7')
INSERT INTO Amir_Masking_Table  VALUES(2,'6','5')
INSERT INTO Amir_Masking_Table  VALUES(2,'7','1')
INSERT INTO Amir_Masking_Table  VALUES(2,'8','3')
INSERT INTO Amir_Masking_Table  VALUES(2,'9','8')


--Masking One Value at a Time
--https://www.mssqltips.com/sqlservertip/3091/masking-personal-identifiable-sql-server-data/

USE Health_DWH
GO
CREATE PROCEDURE dbo.Amir_SSN_Mask 
      -- Add the parameters for the stored procedure here
      @SSN_IN varchar(9), 
      @SSN_OUT varchar(9) OUTPUT
AS
-- Declare incoming (@In) and outgoing (@Out) characters
DECLARE
             @In1 char(1)
            ,@In2 char(1)
            ,@In3 char(1)
            ,@In4 char(1)
            ,@In5 char(1)
            ,@In6 char(1)
            ,@In7 char(1)
            ,@In8 char(1)
            ,@In9 char(1)
            ,@Out1 char(1)
            ,@Out2 char(1)
            ,@Out3 char(1)
            ,@Out4 char(1)
            ,@Out5 char(1)
            ,@Out6 char(1)
            ,@Out7 char(1)
            ,@Out8 char(1)
            ,@Out9 char(1)
            
 --Extract individual characters from @SSN_IN
      SET @In1 =  SUBSTRING(@SSN_IN,1,1)
      SET @In2 =  SUBSTRING(@SSN_IN,2,1)
      /*SET @In3 =  SUBSTRING(@SSN_IN,3,1)
      SET @In4 =  SUBSTRING(@SSN_IN,4,1)
      SET @In5 =  SUBSTRING(@SSN_IN,5,1)
      SET @In6 =  SUBSTRING(@SSN_IN,6,1)
      SET @In7 =  SUBSTRING(@SSN_IN,7,1)
      SET @In8 =  SUBSTRING(@SSN_IN,8,1)
      SET @In9 =  SUBSTRING(@SSN_IN,9,1)
      */
   --A SUBSTRING function sequentially extracts each of the up to nine characters from the input parameter to the @In1 through @In9 local variables. SELECT statements sequentially look up the original characters for each position in Amir_Masking_Table to find a matching mask text value from the table.   
      
      
      -- Assign MaskText for corresponding
      -- OriginalText
      SET @Out1 = 
      (
      SELECT MaskText
      FROM dbo.Amir_Masking_Table
      WHERE
                  PositionNumber = 1
                  AND
                  OriginalText = @In1)            
      SET @Out1 =  ISNULL(@Out1,@In1)                 
      SET @Out2 = 
      (
      SELECT MaskText
      FROM dbo.Amir_Masking_Table
      WHERE
                  PositionNumber = 2
                  AND
                  OriginalText = @In2)
      SET @Out2 =  ISNULL(@Out2,@In2)
      
   --The last part of the masking implementation is to construct the output parameter from the nine transformed values for the input parameter. 
     -- Print Original Text SSN_IN version
      -- Print Masked Text SSN_OUT version
      Print @SSN_IN           
      SET @SSN_OUT = @Out1 + @Out2 
      --SET @SSN_OUT = @Out1 + @Out2 + @Out3  + @Out4 + @Out5 + @Out6 + @Out7 + @Out8  + @Out9
      PRINT @SSN_OUT