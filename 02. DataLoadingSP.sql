/***********************************************
** File: 02.DataLoadingSP.sql
** Desc: SP for Cleaning the records and enter only valid data.
** Auth: Debadutta Dey
** Date: 07/01/2018
************************************************/
USE KCC;

SET SQL_SAFE_UPDATES = 0;
DROP PROCEDURE IF EXISTS SP_InsertData; 
DELIMITER //

CREATE  PROCEDURE `SP_InsertData`() 
BEGIN

	DECLARE  V_season      	VARCHAR(100);
	DECLARE  V_Sector      	VARCHAR(100);
	DECLARE  V_Category    	VARCHAR(100);
	DECLARE  V_Crop        	VARCHAR(100);
	DECLARE  V_QueryType   	VARCHAR(100);
	DECLARE  V_QueryText	VARCHAR(5000);
	DECLARE  V_KCCAns	    VARCHAR(5000);
	DECLARE  V_StateName	VARCHAR(100);
	DECLARE  V_DistrictName	VARCHAR(100);
	DECLARE  V_BlockName	VARCHAR(100);
	DECLARE  V_CreatedOn 	VARCHAR(5000);
    DECLARE  V_id           INT;
    DECLARE  V_Crid         INT;
    DECLARE  done           INT DEFAULT 0;
    DECLARE  V_sid          INT;
    DECLARE  V_did          INT;
    DECLARE  V_Blid         INT;


DECLARE Cur1 CURSOR FOR
	select DISTINCT * from (
	SELECT CASE  WHEN (ifNULL(Season,'')='') then case when MONTH(CREATEDON) between 4 and 6 THEN 'KHARIF' 
                                                       when MONTH(CREATEDON) between 7 and 9 THEN 'ZAID KHARIF' 
when MONTH(CREATEDON) between 10 and 12 THEN 'Rabi' 
when MONTH(CREATEDON) between 1 and 3 THEN 'ZAID Rabi' 
		   END ELSE SEASON end Season,
		  Sector ,
	  Category ,
	  Crop ,
	  	  CASE  WHEN  lower(QueryText) LIKE '%weather%' 
					THEN 'Weather' 
			WHEN  lower(QueryText) LIKE '%subsidy%'
					THEN 'Government Schemes' 
			WHEN lower(QueryText) LIKE '%soil test%'
					THEN 'Soil Testing' 
			WHEN lower(KCCAns) LIKE '%fertilizer%' 
					OR lower(KCCAns) LIKE '%sprey%'
					OR lower(KCCAns) LIKE '%spray%'
					OR lower(QueryText) LIKE '%spray%'
                    OR lower(QueryText) LIKE '%GRAM%'
					OR lower(QueryText) LIKE '%sprey%'  
					OR lower(QueryText) LIKE '%fertilizer%' 
                    OR lower(QueryText) LIKE '%fertililizer%' 
                     OR lower(QueryText) LIKE '%meal%'
                    OR lower(QueryText) LIKE '%paddy%'
                    OR lower(QueryText) LIKE '%dhan%'
                    OR lower(QueryText) LIKE '%aonla%'
                    OR lower(QueryText) LIKE '%SEED%' 
                    OR lower(QueryText) LIKE '%flowering%'  
                    OR lower(QueryText) LIKE '%root%'
					OR lower(QueryText) LIKE '%pest%' 
					OR lower(QueryText) LIKE '%control%'
                    OR lower(QueryText) LIKE '%sarso%'
					OR lower(QueryText) LIKE '%september%'
					OR lower(QueryText) LIKE '%bajr%'
                    OR lower(QueryText) LIKE '%aaloo%'
                    OR lower(QueryText) LIKE '%jawar%'
                    OR lower(QueryText) LIKE '%baign%'
					OR lower(QueryText) LIKE '%kha%'
					OR  lower(QueryText) LIKE '%weed%'
					OR  lower(QueryText) LIKE '%fungus%'
					OR lower(KCCAns) LIKE '%use%'
                    OR lower(KCCAns) LIKE '%ML%'
                    OR lower(KCCAns) LIKE '%GRAM%'
                    OR lower(KCCAns) LIKE '%GRM%'
                    OR lower(KCCAns) LIKE '%GM%'
                    OR lower(KCCAns) LIKE '%KG%'
                    OR lower(KCCAns) LIKE '%urea%'
					OR lower(QueryText) LIKE '%bacterial%'
                    or lower(KCCAns) LIKE '%ferilizer%' 
                    or lower(KCCAns) LIKE '%/li%' 
                    or lower(KCCAns) LIKE '%/lt%' 
                     or lower(KCCAns) LIKE '%/ lt%' 
                    or lower(KCCAns) LIKE '%chemical%' 
                    OR lower(QueryText) LIKE '%chemical%'
                    Or lower(KCCAns) LIKE '%G/%' 
                    Or lower(KCCAns) LIKE '%carbofuron%'
                     OR lower(QueryText) LIKE '%/li%'
                       Or lower(KCCAns) LIKE '%mixture%'
                        Or lower(KCCAns) LIKE '%profinophos%'
	                  Or lower(KCCAns) LIKE '%dinocab%'
                    Or lower(KCCAns) LIKE '%nerbicide%'
                  Or lower(KCCAns) LIKE '%pendimethalin%' 
                  Or lower(KCCAns) LIKE '%acephate%'
                  Or lower(QueryText) LIKE '%grem%'
			THEN 'Fertilizer Use and Availability'

			WHEN lower(QueryText) LIKE '%water logging%'  
			OR lower(QueryText) LIKE '%UPCURLING%' 
                OR lower(QueryText) LIKE '%DISEASE%'
            OR lower(kccans) LIKE '%crop rotation%' 
            OR lower(QueryText) LIKE '%nutrient deficiency%'
            OR lower(QueryText) LIKE '%leaf spot%'
                    OR lower(QueryText) LIKE '%micro nutrient%'
					OR lower(QueryText) LIKE '%leaf curl%'
              OR lower(QueryText) LIKE '%NOT GERMI%'
			 OR lower(QueryText) LIKE '%Plant Prot%'
					THEN 'Plant Protection' 

			WHEN  lower(QueryText) LIKE '%ask%' 
				OR  lower(QueryText) LIKE '%Market%' 
				 OR lower(QueryText) LIKE '%info%' 
               OR lower(QueryText) LIKE '%date%' 
               OR lower(QueryText) LIKE '%days%' 
               OR lower(QueryText) LIKE '%inter crop%' 
				OR lower(QueryText) LIKE '%seed availability%' 
               OR lower(QueryText) LIKE '%seedavailability%' 
               OR lower(QueryText) LIKE '%moisture%' 
               OR lower(QueryText) LIKE '%flower drop%'
               OR lower(KCCAns) LIKE '%month%'
                OR lower(QueryText) LIKE '%crop peri%'
				OR lower(QueryText) LIKE '%varities%'
               OR lower(QueryText) LIKE '%variETY%'
               OR  lower(QueryText) LIKE '%STEM Bor%'
                    OR  lower(QueryText) LIKE '%leaf dry%'
               OR lower(KCCAns) LIKE '%variETY%'
                OR lower(QueryText) LIKE '%verities%'
                oR QueryText LIKE '%varEITY%'
                oR QueryText LIKE '%varites%'
                 oR QueryText LIKE '%varitY%'
                 OR QueryText LIKE '%VARIETIES%'
                 OR lower(KCCAns) LIKE '%time%'
				OR lower(KCCAns) LIKE '%info%'
                OR lower(KCCAns) LIKE '%thank%'
                OR lower(KCCAns) LIKE '%sorry%'
				OR lower(KCCAns) LIKE '%recommend%'
                OR lower(KCCAns) LIKE '%NO PROBLEM%'
               OR lower(KCCAns) LIKE '%dhm %'
               OR QueryText LIKE '%RATE%'
           OR lower(KCCAns) LIKE '%symptoms clearly%'
                OR lower(KCCAns) LIKE '%planting mater%'
                OR lower(KCCAns) LIKE '%nonbt%'
                OR lower(KCCAns) LIKE '%18700-%'
				OR KCCAns LIKE '%080%'
                 OR KCCAns LIKE '%3800%'
               OR KCCAns LIKE '%1000%'
                 OR KCCAns LIKE '%/hect%'
                OR KCCAns LIKE '%helpline%'
                OR Querytext LIKE '%irrigation problem%'
				OR lower(KCCAns) LIKE '%LOCAL AVERAGE%'
                or( ifnull(Querytype,'')='' and Sector ='ANIMAL HUSBANDRY')
                or( ifnull(Querytype,'')='' and Category ='Others')
                OR ( ifnull(Querytype,'')='' and Querytext like'%SEASON%')
                OR ( ifnull(Querytype,'')='' and Querytext LIKE'%sowing%')
					THEN 'Information' 

		   WHEN  lower(QueryText) LIKE '%registration in kisan%' 
				   OR lower(QueryText) LIKE '%farmer id%'  
                  OR lower(QueryText) LIKE '%availability%' 
                   OR lower(KCCAns) LIKE '%1800%' 
                   OR lower(KCCAns) LIKE '%1300%' 
                   OR lower(KCCAns) LIKE '%040%' 
                   OR lower(KCCAns) LIKE '%085%' 
                 OR lower(KCCAns) LIKE '%bait%'  
                     OR lower(KCCAns) LIKE '%dap APPL%'
                   OR lower(QueryText) LIKE '%REG IN%'   
                    OR lower(QueryText) LIKE '%REGISTRATION%' 
					THEN 'Cultural Practices'

			   ELSE QueryType
	  END
      QueryType,
	  RTRIM(QueryText) QueryText,
	        case when locate('&#',kccans,1)=0 then rtrim (kccans)
            else rtrim(left(kccans,locate('&#',kccans,1)-1)) end kccans,
	  RTRIM(StateName) StateName,
	  RTRIM(DistrictName) DistrictName,
	  RTRIM(BlockName) BlockName,
	  CreatedOn 
	FROM stagingtable
	WHERE (KCCAns not like '&#%' or QueryText not like '&#%')
	) x
	
;
DECLARE CONTINUE handler FOR NOT FOUND SET done=1;

OPEN Cur1;
get_detail: LOOP
FETCH CUR1 INTO V_season,V_Sector, V_Category,V_Crop,V_QueryType,V_QueryText,V_KCCAns,V_StateName,	
	            V_DistrictName,V_BlockName,	V_CreatedOn;
IF done=1 THEN LEAVE get_detail; END IF;

INSERT INTO Season (Season_Name) 
SELECT * FROM ( SELECT V_season ) AS Y 
WHERE NOT EXISTS (	SELECT Season_Name 
					FROM Season 
                    WHERE ifnull(Season_Name,'')=V_season
				 );

SELECT Season_Id INTO V_id FROM Season WHERE Season_Name= V_season;


INSERT INTO Sector (Sector_Name,Season_Id) 
SELECT * FROM ( SELECT V_Sector,V_id ) AS Y 
WHERE NOT EXISTS (	SELECT Sector_Name,Season_Id
					FROM   Sector 
                    WHERE  ifnull(Sector_Name,'') = V_Sector
                    AND    Season_Id = V_id
				 );
SELECT Sector_Id INTO V_id FROM Sector WHERE Sector_Name= V_Sector AND    Season_Id = V_id;

INSERT INTO Category (Category_Name,Sector_Id) 
SELECT * FROM (SELECT V_Category,V_id ) AS Y 
WHERE NOT EXISTS (	SELECT Category_Name,Sector_Id 
					FROM   Category 
                    WHERE  ifnull(Category_Name,'')=V_Category
                    AND    Sector_Id = V_id
				 );
SELECT Category_Id INTO V_id FROM Category WHERE Category_Name= V_Category AND    Sector_Id = V_id;

INSERT INTO Crop (Crop_Name,Category_Id) 
SELECT * FROM (SELECT V_Crop,V_id ) AS Y 
WHERE NOT EXISTS (	SELECT Crop_Name 
					FROM   Crop 
                    WHERE  ifnull(Crop_Name,'') = V_Crop
                    AND    Category_Id = V_id
				 );

SELECT Crop_Id INTO V_Crid FROM Crop WHERE Crop_Name= V_Crop AND    Category_Id = V_id;

INSERT INTO QueryType_Info (QueryType) 
SELECT * FROM (SELECT V_QueryType ) AS Y 
WHERE NOT EXISTS (	SELECT QueryType 
					FROM   QueryType_Info 
                    WHERE  ifnull(QueryType,'') = V_QueryType
				 );

SELECT QueryType_Id INTO V_id FROM QueryType_Info WHERE QueryType= V_QueryType;


INSERT INTO Query_Info (QueryType_Id,Query_Text,Query_Answer,Crop_Id) 
SELECT * FROM (SELECT V_id,V_QueryText,V_KCCAns,V_Crid  ) AS Y 
WHERE NOT EXISTS (	SELECT QueryType_Id,Query_Text,Query_Answer,Crop_Id
					FROM  Query_Info 
                    WHERE ifnull(Query_Text,'')   = V_QueryText
                    AND   ifnull(Query_Answer,'') = V_KCCAns
                    AND   Crop_Id      = V_Crid
					AND QueryType_Id=V_id
				 );
#SET V_id = LAST_INSERT_ID();
SELECT Query_Id INTO V_id
 FROM Query_Info WHERE Query_Text= V_QueryText
AND   Query_Answer = V_KCCAns
                    AND   Crop_Id      = V_Crid
AND QueryType_Id=V_id;
#SELECT V_QueryText;
INSERT INTO State_Info (State_Name) 
SELECT * FROM (SELECT V_StateName  ) AS Y 
WHERE NOT EXISTS (	SELECT State_Name 
					FROM State_Info 
                    WHERE ifnull(State_Name,'') = V_StateName
				 );
#SET V_id = LAST_INSERT_ID();
SELECT State_Id INTO V_sid FROM State_Info WHERE State_Name= V_StateName;

INSERT INTO District_Info(District_Name,State_Id) 
SELECT * FROM (SELECT V_DistrictName, V_sid  ) AS Y 
WHERE NOT EXISTS (	SELECT District_Name 
					FROM District_Info 
                    WHERE ifnull(District_Name,'') =V_DistrictName
                    AND State_Id=V_sid
				 );
#SET V_id = LAST_INSERT_ID();
SELECT District_Id INTO V_did FROM District_Info WHERE District_Name= V_DistrictName AND State_Id=V_sid;

INSERT INTO Block_Info (Block_Name,District_Id) 
SELECT * FROM (SELECT V_BlockName, V_did) AS Y 
WHERE NOT EXISTS (	SELECT Block_Name 
					FROM Block_Info 
                    WHERE ifnull(Block_Name,'') = V_BlockName
					AND District_Id=V_did
				 );
#SET V_id = LAST_INSERT_ID();
SELECT Block_Id INTO V_Blid FROM Block_Info WHERE Block_Name= V_BlockName AND District_Id=V_did;

INSERT INTO Block_QueryInfo (Query_Id,Block_Id,Created_Date) 
SELECT * FROM (SELECT V_id, V_Blid,V_CreatedOn) AS Y 
WHERE NOT EXISTS (	SELECT 1 
					FROM Block_QueryInfo 
                    WHERE Query_Id = V_id
					AND Block_Id=V_Blid
                    And Created_Date=V_CreatedOn
				 );

END LOOP get_detail;
CLOSE Cur1;

DELETE FROM stagingtable; 

COMMIT;
END //

DELIMITER ; //

