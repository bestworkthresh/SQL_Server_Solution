
--切換至作用DB
USE COMPDB
GO
--########################################################################################
--※_TABLE層
--※183
  DELETE TB_183
  INSERT INTO TB_183
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       *
FROM [183DB].IFRSRPDB.SYS.TABLES
WHERE NAME NOT LIKE '(%' --(開頭之TABLE不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       *
FROM [183DB].IFRSSTG.SYS.TABLES
WHERE NAME NOT LIKE '(%' --(開頭之TABLE不納入比較

--※114
  DELETE TB_114
  INSERT INTO TB_114
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       *
FROM [114DB].IFRSRPDB.SYS.TABLES
WHERE NAME NOT LIKE '(%' --(開頭之TABLE不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       *
FROM [114DB].IFRSSTG.SYS.TABLES
WHERE NAME NOT LIKE '(%' --(開頭之TABLE不納入比較

  --比對 IFRSSTG  sit 183 176 114 並寫入 COMP_TB_RESULT 內

IF EXISTS
  (SELECT *
   FROM SYS.OBJECTS
   WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[COMP_TB_RESULT]')
     AND TYPE IN (N'U'))
DROP TABLE [DBO].COMP_TB_RESULT


  SELECT ISNULL(A.DBNAME, B.DBNAME) AS DBNAME,
          A.NAME AS 'TB_114',
          A.MODIFY_DATE AS 'TB_114_MOD_TIME',
          B.NAME AS 'TB_183',
          B.MODIFY_DATE AS 'TB_183_MOD_TIME'
          INTO COMP_TB_RESULT
   FROM COMPDB..TB_114 A
   FULL OUTER JOIN COMPDB..TB_183 B ON A.DBNAME=B.DBNAME
   AND A.NAME=B.NAME



  --比對結果撈取
SELECT DBNAME,TB_114,TB_114_MOD_TIME,TB_183,TB_183_MOD_TIME
,'IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N''[DBO].['+TB_183+']'') AND TYPE IN (N''U'')) DROP TABLE ['+ TB_183 + ']' AS '183_SQLCMD'
FROM COMP_TB_RESULT
WHERE TB_183 IS NULL
  OR TB_114 IS NULL
ORDER BY DBNAME,TB_114,TB_114_MOD_TIME DESC


--==========================================================================================
          
--=============


--########################################################################################
--※_COLUMN層
--※183
DELETE COL_183
INSERT INTO COL_183
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       *
FROM [183DB].IFRSRPDB.SYS.COLUMNS
UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       *
FROM [183DB].IFRSSTG.SYS.COLUMNS


--※114
DELETE COL_114
INSERT INTO COL_114
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       *
FROM [114DB].IFRSRPDB.SYS.COLUMNS
UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       *
FROM [114DB].IFRSSTG.SYS.COLUMNS


--=================================================================================================================
--比對sit及183--程式要和以上同
IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[CSET114]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].CSET114  

         --SELECT B.NAME AS TBNAME,A.NAME AS COLNAME,ROW_NUMBER() OVER(PARTITION BY B.NAME ORDER BY A.COLUMN_ID ASC) AS COLUMN_ID,A.SYSTEM_TYPE_ID,A.USER_TYPE_ID,A.MAX_LENGTH,A.PRECISION,A.SCALE,A.COLLATION_NAME,A.IS_NULLABLE,A.IS_ROWGUIDCOL,A.IS_IDENTITY,A.IS_COMPUTED,A.IS_FILESTREAM,A.IS_REPLICATED,A.IS_NON_SQL_SUBSCRIBED,A.IS_MERGE_PUBLISHED,A.IS_DTS_REPLICATED,A.IS_XML_DOCUMENT,A.XML_COLLECTION_ID,A.RULE_OBJECT_ID,A.IS_SPARSE,A.IS_COLUMN_SET
SELECT  ISNULL(A.DBNAME, B.DBNAME) AS DBNAME,
       B.NAME AS TBNAME,
       A.NAME AS COLNAME,
       ROW_NUMBER() OVER(PARTITION BY ISNULL(A.DBNAME, B.DBNAME), B.NAME
                         ORDER BY A.COLUMN_ID ASC) AS COLUMN_ID,
       A.SYSTEM_TYPE_ID,
       A.USER_TYPE_ID,
       A.MAX_LENGTH,
       A.PRECISION,
       A.SCALE,
       A.COLLATION_NAME,
       A.IS_NULLABLE,
       A.IS_ROWGUIDCOL,
       A.IS_IDENTITY,
       A.IS_COMPUTED,
       A.IS_FILESTREAM,
       A.IS_REPLICATED,
       A.IS_NON_SQL_SUBSCRIBED,
       A.IS_MERGE_PUBLISHED,
       A.IS_DTS_REPLICATED,
       A.IS_XML_DOCUMENT,
       A.XML_COLLECTION_ID,
       A.RULE_OBJECT_ID,
       A.IS_SPARSE,
       A.IS_COLUMN_SET 
INTO CSET114
FROM COL_114 A
INNER JOIN TB_114 B ON A.DBNAME=B.DBNAME
AND A.OBJECT_ID=B.OBJECT_ID
--where exists  ( select 1
--              from COMP_TB_RESULT x
--             where x.TB_114=x.TB_176 --針對183及176 共有的TABLE進行欄位比對
--               and b.dbname=x.dbname
--               and b.name=x. TB_176
--             )

IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[CSET176]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].CSET183  

        -- SELECT B.NAME AS TBNAME,A.NAME AS COLNAME,ROW_NUMBER() OVER(PARTITION BY B.NAME ORDER BY A.COLUMN_ID ASC) AS COLUMN_ID,A.SYSTEM_TYPE_ID,A.USER_TYPE_ID,A.MAX_LENGTH,A.PRECISION,A.SCALE,A.COLLATION_NAME,A.IS_NULLABLE,A.IS_ROWGUIDCOL,A.IS_IDENTITY,A.IS_COMPUTED,A.IS_FILESTREAM,A.IS_REPLICATED,A.IS_NON_SQL_SUBSCRIBED,A.IS_MERGE_PUBLISHED,A.IS_DTS_REPLICATED,A.IS_XML_DOCUMENT,A.XML_COLLECTION_ID,A.RULE_OBJECT_ID,A.IS_SPARSE,A.IS_COLUMN_SET

SELECT  ISNULL(A.DBNAME, B.DBNAME) AS DBNAME,
       B.NAME AS TBNAME,
       A.NAME AS COLNAME,
       ROW_NUMBER() OVER(PARTITION BY ISNULL(A.DBNAME, B.DBNAME), B.NAME
                         ORDER BY A.COLUMN_ID ASC) AS COLUMN_ID,
       A.SYSTEM_TYPE_ID,
       A.USER_TYPE_ID,
       A.MAX_LENGTH,
       A.PRECISION,
       A.SCALE,
       A.COLLATION_NAME,
       A.IS_NULLABLE,
       A.IS_ROWGUIDCOL,
       A.IS_IDENTITY,
       A.IS_COMPUTED,
       A.IS_FILESTREAM,
       A.IS_REPLICATED,
       A.IS_NON_SQL_SUBSCRIBED,
       A.IS_MERGE_PUBLISHED,
       A.IS_DTS_REPLICATED,
       A.IS_XML_DOCUMENT,
       A.XML_COLLECTION_ID,
       A.RULE_OBJECT_ID,
       A.IS_SPARSE,
       A.IS_COLUMN_SET 
INTO CSET183
FROM COL_183 A
INNER JOIN TB_183 B ON A.DBNAME=B.DBNAME
AND A.OBJECT_ID=B.OBJECT_ID
--where exists  ( select 1
--              from COMP_TB_RESULT x
--             where x.TB_sit=x.TB_183 --針對183及176 共有的TABLE進行欄位比對
--               and b.dbname=x.dbname
--               and b.name=x. TB_183
--             )

 

SELECT DISTINCT DBNAME,TBNAME
FROM (

SELECT 'A'AS C1,*
FROM (
       SELECT * FROM CSET114
       EXCEPT                                                       
       SELECT * FROM CSET183
     )X
UNION ALL      
SELECT 'B',*
FROM (
       SELECT * FROM CSET183
       EXCEPT                                                       
       SELECT * FROM CSET114
     )X
    )Y 
ORDER BY DBNAME,TBNAME
/*NOTE

IFRSRPDB	JH_WS02_SCHDL_LOCUS_LIST
IFRSRPDB	JH_WS02_SCHDL_UX_LIST
IFRSSTG	ES_STG_LA_QL1015
IFRSSTG	ES_STG_LA_QL1015_HIST_T
IFRSSTG	ES_STG_LA_QL1015_HIST_T4
IFRSSTG	ES_STG_TW_LFDAJ
IFRSSTG	ES_STG_TW_LFDAJ_HIST
IFRSSTG	ES_STG_WRITE_OFF
IFRSSTG	ES_STG_WRITE_OFF_HIST
IFRSRPDB	USERS
*/
/*針對單張不同的資料表做查詢*/
DECLARE @DBNAME VARCHAR(100)
       ,@TBNAME VARCHAR(100)
SET @DBNAME='IFRSRPDB'
SET @TBNAME='JH_CDE_ACCOUNT_GROUP'

SELECT * FROM CSET183 WHERE DBNAME=@DBNAME AND TBNAME=@TBNAME
EXCEPT 
SELECT * FROM CSETsit WHERE DBNAME=@DBNAME AND TBNAME=@TBNAME

SELECT * FROM CSETsit WHERE DBNAME=@DBNAME AND TBNAME=@TBNAME
EXCEPT 
SELECT * FROM CSET183 WHERE DBNAME=@DBNAME AND TBNAME=@TBNAME

SELECT * FROM CSETsit WHERE DBNAME=@DBNAME AND TBNAME=@TBNAME ORDER BY COLUMN_ID
SELECT * FROM CSET183 WHERE DBNAME=@DBNAME AND TBNAME=@TBNAME ORDER BY COLUMN_ID



--==============================================================================================================
--※_比對VW

USE COMPDB
GO
--※183
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[VW_183]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].VW_183

SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       A.*,
       B.DEFINITION INTO VW_183
FROM [183DB].IFRSRPDB.SYS.VIEWS A
INNER JOIN [183DB].IFRSRPDB.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       A.*,
       B.DEFINITION
FROM [183DB].IFRSSTG.SYS.VIEWS A
INNER JOIN [183DB].IFRSSTG.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較


--※114
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[VW_114]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].VW_114

SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       A.*,
       B.DEFINITION INTO VW_114
FROM [114DB].IFRSRPDB.SYS.VIEWS A
INNER JOIN [114DB].IFRSRPDB.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       A.*,
       B.DEFINITION
FROM [114DB].IFRSSTG.SYS.VIEWS A
INNER JOIN [114DB].IFRSSTG.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較




--比對 IFRSSTG  114 183 176 並寫入 COMP_VW_RESULT 內
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[COMP_VW_RESULT]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].COMP_VW_RESULT  

 SELECT ISNULL(A.DBNAME, B.DBNAME) AS DBNAME,
          A.NAME AS 'VW_114',
          A.MODIFY_DATE AS 'VW_114_MOD_TIME',
          A.DEFINITION AS 'VW_114_DEF',
          B.NAME AS 'VW_183',
          B.MODIFY_DATE AS 'VW_183_MOD_TIME',
          B.DEFINITION AS 'VW_183_DEF'
   INTO COMP_VW_RESULT
   FROM COMPDB..VW_114 A
   FULL OUTER JOIN COMPDB..VW_183 B ON A.DBNAME=B.DBNAME
   AND A.NAME=B.NAME


--比對結果撈取
--先比物件是否存在
SELECT *
FROM COMP_VW_RESULT
WHERE  VW_183 IS NULL
  OR VW_114 IS NULL
ORDER BY DBNAME,VW_114,VW_114_MOD_TIME DESC




--再比物件內容實際語法是否相同
SELECT *
FROM COMP_VW_RESULT
WHERE  VW_183 IS NOT NULL
  AND VW_114 IS NOT NULL
  AND VW_183_DEF<>VW_114
  AND REPLACE(RTRIM(LTRIM(VW_183_DEF)), CHAR(13)+CHAR(10), '')<>REPLACE(RTRIM(LTRIM(VW_114)), CHAR(13)+CHAR(10), '')
ORDER BY DBNAME,VW_114,VW_114_MOD_TIME DESC




--========================================================================================================================
--※比對FUNCTION


USE COMPDB
GO
--※183
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[FN_183]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].FN_183
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       A.*,
       B.DEFINITION INTO FN_183
FROM [183DB].IFRSRPDB.SYS.OBJECTS A
INNER JOIN [183DB].IFRSRPDB.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE TYPE IN (N'FN',
                N'IF',
                 N'TF',
                  N'FS',
                   N'FT')
  AND NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       A.*,
       B.DEFINITION
FROM [183DB].IFRSSTG.SYS.OBJECTS A
INNER JOIN [183DB].IFRSSTG.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE TYPE IN (N'FN',
                N'IF',
                 N'TF',
                  N'FS',
                   N'FT')
  AND NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

--※114
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[FN_114]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].FN_114
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       A.*,
       B.DEFINITION INTO FN_114
FROM [114DB].IFRSRPDB.SYS.OBJECTS A
INNER JOIN [114DB].IFRSRPDB.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE TYPE IN (N'FN',
                N'IF',
                 N'TF',
                  N'FS',
                   N'FT')
  AND NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       A.*,
       B.DEFINITION
FROM [114DB].IFRSSTG.SYS.OBJECTS A
INNER JOIN [114DB].IFRSSTG.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE TYPE IN (N'FN',
                N'IF',
                 N'TF',
                  N'FS',
                   N'FT')
  AND NAME NOT LIKE '(%' --(OLD)開頭之不納入比較


  --比對 IFRSSTG  114 183 176 並寫入 COMP_FN_RESULT 內
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[COMP_FN_RESULT]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].COMP_FN_RESULT  

SELECT ISNULL(A.DBNAME, B.DBNAME) AS DBNAME ,
          A.NAME AS 'FN_114',
          A.MODIFY_DATE AS FN_114_MOD_TIME,
          A.DEFINITION AS FN_114_DEF ,
          B.NAME AS 'FN_183',
          B.MODIFY_DATE AS FN_183_MOD_TIME,
          B.DEFINITION AS FN_183_DEF
  INTO COMP_FN_RESULT
   FROM COMPDB..FN_114 A
   FULL OUTER JOIN COMPDB..FN_183 B ON A.DBNAME=B.DBNAME
   AND A.NAME=B.NAME


--比對結果撈取
--先比物件是否存在
SELECT *
FROM COMP_FN_RESULT
WHERE FN_183 IS NULL
  OR FN_114 IS NULL
ORDER BY DBNAME,FN_114,FN_114_MOD_TIME DESC

--再比物件內容實際語法是否相同
SELECT *
FROM COMP_FN_RESULT
WHERE FN_114 IS NOT NULL
  AND FN_183 IS NOT NULL
  AND FN_183_DEF <> FN_114_DEF
  AND REPLACE(RTRIM(LTRIM(FN_183_DEF)), CHAR(13)+CHAR(10), '')<>REPLACE(RTRIM(LTRIM(FN_114_DEF)), CHAR(13)+CHAR(10), '')
ORDER BY DBNAME,FN_114,FN_114_MOD_TIME DESC

--==============================================================================================================
--※_比對SP

USE COMPDB
GO
--※183
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_183]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].SP_183
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       A.*,
       B.DEFINITION INTO SP_183
FROM [183DB].IFRSRPDB.SYS.PROCEDURES A
INNER JOIN [183DB].IFRSRPDB.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       A.*,
       B.DEFINITION
FROM [183DB].IFRSSTG.SYS.PROCEDURES A
INNER JOIN [183DB].IFRSSTG.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

--※114
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_114]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].SP_114
SELECT CONVERT(VARCHAR(100), 'IFRSRPDB') AS DBNAME,
       A.*,
       B.DEFINITION INTO SP_114
FROM [114DB].IFRSRPDB.SYS.PROCEDURES A
INNER JOIN [114DB].IFRSRPDB.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較

UNION ALL
SELECT CONVERT(VARCHAR(100), 'IFRSSTG') AS DBNAME,
       A.*,
       B.DEFINITION
FROM [114DB].IFRSSTG.SYS.PROCEDURES A
INNER JOIN [114DB].IFRSSTG.SYS.SQL_MODULES B ON A.OBJECT_ID=B.OBJECT_ID
WHERE NAME NOT LIKE '(%' --(OLD)開頭之不納入比較



--比對 IFRSSTG  114 183 176 並寫入 COMP_SP_RESULT 內
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[COMP_SP_RESULT]') AND TYPE IN (N'U'))
    DROP TABLE [DBO].COMP_SP_RESULT  

  SELECT ISNULL(A.DBNAME, B.DBNAME) AS DBNAME ,
          A.NAME AS 'SP_114',
          A.MODIFY_DATE AS SP_114_MOD_TIME,
          A.DEFINITION AS SP_114_DEF ,
          B.NAME AS 'SP_183',
          B.MODIFY_DATE AS SP_183_MOD_TIME,
          B.DEFINITION AS SP_183_DEF
   INTO COMP_SP_RESULT
   FROM COMPDB..SP_114 A
   FULL OUTER JOIN COMPDB..SP_183 B ON A.DBNAME=B.DBNAME
   AND A.NAME=B.NAME


  --比對結果撈取
--先比物件是否存在
SELECT 
DBNAME,SP_114,SP_114_MOD_TIME,SP_114_DEF,SP_183,SP_183_MOD_TIME,SP_183_DEF,'IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N''[DBO].['+SP_183+']'') AND TYPE IN (N''P'', N''PC'')) DROP PROCEDURE ['+ SP_183 + ']' AS 'SQLCMD'
FROM COMP_SP_RESULT
WHERE SP_114 IS  NULL
  OR SP_183 IS  NULL
ORDER BY DBNAME,SP_114,SP_114_MOD_TIME DESC


--再比物件內容實際語法是否相同
SELECT *
FROM COMP_SP_RESULT
WHERE SP_114 IS  NULL
  OR SP_183 IS  NULL
  OR SP_114<>SP_183_DEF
  OR REPLACE(RTRIM(LTRIM(SP_114_DEF)), CHAR(13)+CHAR(10), '')<>REPLACE(RTRIM(LTRIM(SP_183_DEF)), CHAR(13)+CHAR(10), '')
ORDER BY DBNAME,SP_114,SP_114_MOD_TIME DESC
         


