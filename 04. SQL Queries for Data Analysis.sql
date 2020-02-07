/***********************************************
** File: 04. SQL Queries for Data Analysis.sql
** Desc: SQL query for creating required tables and views
** Auth: Debadutta Dey
** Date: 07/01/2018
************************************************/
USE KCC;

/* Insight # 1: Call counts for each state*/
SELECT 
    query_text, state_name, icount
FROM
    (SELECT 
        qi.query_text, l.state_name, COUNT(BQ.QUERY_ID) ICOUNT
    FROM
        block_queryinfo bq
    JOIN query_info qi ON bq.query_id = qi.query_id
    JOIN location l ON bq.block_id = l.location_id
    GROUP BY qi.query_text , l.state_name) x
ORDER BY ICOUNT DESC;

/* Insight # 2: Call Count for each state and season*/
SELECT 
    State_Name,
    IFNULL(SUM(CASE
                WHEN Season = 'Zaid Kharif' THEN QUERYCOUNT
            END),
            0) 'Zaid Kharif',
    IFNULL(SUM(CASE
                WHEN Season = 'Jayad' THEN QUERYCOUNT
            END),
            0) 'Jayad',
    IFNULL(SUM(CASE
                WHEN Season = 'Kharif' THEN QUERYCOUNT
            END),
            0) 'Kharif',
    IFNULL(SUM(CASE
                WHEN Season = 'Rabi' THEN QUERYCOUNT
            END),
            0) 'Rabi'
FROM
    (SELECT 
        L.State_Name, CD.Season, COUNT(BQI.QUERY_ID) QUERYCOUNT
    FROM
        block_queryinfo BQI
    JOIN location L ON BQI.Block_Id = L.Location_Id
    JOIN QUERY_INFO QI ON QI.QUERY_ID = BQI.QUERY_ID
    JOIN crop_details CD ON CD.CROP_ID = QI.Crop_Id
    GROUP BY L.State_Name , CD.Season) x
GROUP BY State_Name;

/* Insight # 3: Most frequent queries among different blocks */
SELECT 
    QI.QUERY_TEXT, L.block_NAME, COUNT(x.block_id) callcount
FROM
    (SELECT 
        BQI.QUERY_ID, BQI.BLOCK_ID
    FROM
        block_queryinfo BQI
    JOIN block_queryinfo BQI1 ON BQI.QUERY_ID = BQI1.QUERY_ID
    WHERE
        BQI.BLOCK_ID <> BQI1.BLOCK_ID UNION SELECT 
        BQI1.QUERY_ID, BQI1.BLOCK_ID
    FROM
        block_queryinfo BQI
    JOIN block_queryinfo BQI1 ON BQI.QUERY_ID = BQI1.QUERY_ID
        AND BQI.BLOCK_ID <> BQI1.BLOCK_ID) x
        JOIN
    QUERY_INFO QI ON QI.QUERY_ID = X.QUERY_ID
        JOIN
    location L ON X.Block_Id = L.Location_Id
GROUP BY Query_Text , block_NAME
ORDER BY Query_Text , callcount DESC;

/* Insight # 4: Most frequent queries per quarter */
SELECT 
    query_text,
    IFNULL(SUM(CASE
                WHEN MONTH(createddate) BETWEEN 1 AND 3 THEN callcount
            END),
            0) 'Quarter1',
    IFNULL(SUM(CASE
                WHEN MONTH(createddate) BETWEEN 4 AND 6 THEN callcount
            END),
            0) 'Quarter2',
    IFNULL(SUM(CASE
                WHEN MONTH(createddate) BETWEEN 7 AND 9 THEN callcount
            END),
            0) 'Quarter3',
    IFNULL(SUM(CASE
                WHEN MONTH(createddate) BETWEEN 10 AND 12 THEN callcount
            END),
            0) 'Quarter4'
FROM
    (SELECT 
        query_text,
            bqi.created_date createddate,
            COUNT(bqi.query_Id) callcount
    FROM
        block_queryinfo bqi
    JOIN query_info qi ON qi.query_id = bqi.query_id
    JOIN location l ON bqi.block_id = l.location_id
    GROUP BY query_text , bqi.created_date) x
GROUP BY query_text;

/* Insight # 5: Create cursor to insert record with primary key - Please note that data should be present in the staging table for below mnetioned cursor to work*/ 
DECLARE V_season       VARCHAR(100);
DECLARE V_Sector       VARCHAR(100); 
DECLARE V_Category     VARCHAR(100);
DECLARE V_Crop         VARCHAR(100);
DECLARE V_QueryType    VARCHAR(100);
DECLARE V_QueryText    VARCHAR(5000);
DECLARE V_KCCAns       VARCHAR(5000);
DECLARE V_StateName    VARCHAR(100); 
DECLARE V_DistrictName VARCHAR(100);
DECLARE V_BlockName    VARCHAR(100);
DECLARE V_CreatedOn    VARCHAR(5000);
DECLARE V_id           INT;
DECLARE V_Crid         INT;
DECLARE done           INT DEFAULT 0;
DECLARE V_sid          INT;
DECLARE V_did          INT;
DECLARE V_Blid         INT;
DECLARE Cur1 CURSOR FOR
SELECT Season,Sector ,Category ,Crop ,QueryType,QueryText,kccans,StateName,DistrictName,BlockName,
	      CreatedOn FROM stagingtable;
DECLARE CONTINUE handler FOR NOT FOUND SET done=1;
OPEN Cur1;
get_detail: LOOP
FETCH CUR1 INTO V_season,V_Sector, V_Category,V_Crop,V_QueryType,V_QueryText,V_KCCAns,V_StateName,	
	            V_DistrictName,V_BlockName,	V_CreatedOn;
IF done=1 THEN LEAVE get_detail; END IF;
INSERT INTO Season (Season_Name) 
SELECT * FROM ( SELECT V_season ) AS Y 
WHERE NOT EXISTS (	SELECT Season_Name FROM Season WHERE ifnull(Season_Name,'')=V_season);
SELECT 
    Season_Id
INTO V_id FROM
    Season
WHERE
    Season_Name = V_season;
INSERT INTO Sector (Sector_Name,Season_Id) 
SELECT * FROM ( SELECT V_Sector,V_id ) AS Y 
WHERE NOT EXISTS (SELECT Sector_Name,Season_Id FROM Sector WHERE  ifnull(Sector_Name,'') = V_Sector
                    AND Season_Id = V_id);
END LOOP get_detail;CLOSE Cur1;

/*Insight # 6: Data deletion without using Primary Key in where clause */

DELETE bqi
FROM block_queryinfo bqi
JOIN location 1 ON bqi.block_id=1.location_id
JOIN query_info qi ON qi.query_id=bqi.query_id
JOIN (
       SELECT hmy FROM block_queryinfo JOIN location 1 ON bqi.block_id=1.location_id
       WHERE 1.state_name='tamilnadu' order by bqi.hmy desc limit 100
      ) x ON x.hmy=bqi.hmy
 WHERE 1.state_name='tamilnadu' 
 
 DELETE qi FROM block_queryinfo bqi
 RIGHT JOIN  query_info qi ON qi.query_id=bqi.query_id
 WHERE bqi.query_id is NULL;
 
SELECT 
    qi.*
FROM
    block_queryinfo bqi
        RIGHT JOIN
    query_info qi ON qi.query_id = bqi.query_id
WHERE
    bqi.query_id IS NULL;
 
      


