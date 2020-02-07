/***********************************************
** File: 01.Database&TableCreation.sql
** Desc: SQL query for creating required tables and views
** Auth: Debadutta Dey
** Date: 07/01/2018
************************************************/
/* Created database KCC */
create database KCC;

use KCC;
/* Created required tables */
drop table if exists Season;
CREATE TABLE Season (
    Season_Id INT NOT NULL AUTO_INCREMENT,
    Season_Name VARCHAR(100),
    PRIMARY KEY (Season_Id)
);

drop table if exists Sector;
CREATE TABLE Sector (
    Sector_Id INT NOT NULL AUTO_INCREMENT,
    Sector_Name VARCHAR(100),
    Season_Id INT,
    PRIMARY KEY (Sector_Id),
    CONSTRAINT FK_Season_Sector FOREIGN KEY (Season_Id)
        REFERENCES Season (Season_Id)
);

drop table if exists Category;
CREATE TABLE Category (
    Category_Id INT NOT NULL AUTO_INCREMENT,
    Category_Name VARCHAR(100),
    Sector_Id INT,
    PRIMARY KEY (Category_Id),
    CONSTRAINT FK_Sector_Category FOREIGN KEY (Sector_Id)
        REFERENCES Sector (Sector_Id)
);

drop table if exists Crop;
CREATE TABLE Crop (
    Crop_Id INT NOT NULL AUTO_INCREMENT,
    Crop_Name VARCHAR(100),
    Category_Id INT,
    PRIMARY KEY (Crop_Id),
    CONSTRAINT FK_Category_Crop FOREIGN KEY (Category_Id)
        REFERENCES Category (Category_Id)
);

drop table if exists QueryType_Info;
CREATE TABLE QueryType_Info (
    QueryType_Id INT NOT NULL AUTO_INCREMENT,
    QueryType VARCHAR(100),
    PRIMARY KEY (QueryType_Id)
);

drop table if exists Query_Info;
CREATE TABLE Query_Info (
    Query_Id INT NOT NULL AUTO_INCREMENT,
    QueryType_Id INT,
    Query_Text VARCHAR(30000),
    Query_Answer VARCHAR(30000),
    Crop_Id INT,
    PRIMARY KEY (Query_Id),
    CONSTRAINT FK_Crop_QueryInfo FOREIGN KEY (Crop_Id)
        REFERENCES Crop (Crop_Id),
    CONSTRAINT FK_QueryTypeInfo_QueryInfo FOREIGN KEY (QueryType_Id)
        REFERENCES QueryType_Info (QueryType_Id)
);

drop table if exists State_Info;
CREATE TABLE State_Info (
    State_Id INT NOT NULL AUTO_INCREMENT,
    State_Name VARCHAR(100),
    PRIMARY KEY (State_Id)
);

drop table if exists District_Info;
CREATE TABLE District_Info (
    District_Id INT NOT NULL AUTO_INCREMENT,
    District_Name VARCHAR(100),
    State_Id INT,
    PRIMARY KEY (District_Id),
    CONSTRAINT FK_StateInfo_DistrictInfo FOREIGN KEY (State_Id)
        REFERENCES State_Info (State_Id)
);

drop table if exists Block_Info;
CREATE TABLE Block_Info (
    Block_Id INT NOT NULL AUTO_INCREMENT,
    Block_Name VARCHAR(100),
    District_Id INT,
    PRIMARY KEY (Block_Id),
    CONSTRAINT FK_DistrictInfo_BlockInfo FOREIGN KEY (District_Id)
        REFERENCES District_Info (District_Id)
);

drop table if exists Block_QueryInfo;
CREATE TABLE Block_QueryInfo (
    HMY INT NOT NULL AUTO_INCREMENT,
    Query_Id INT,
    Block_Id INT,
    Created_Date DATETIME,
    PRIMARY KEY (HMY),
    CONSTRAINT FK_QueryInfo_BlockQueryInfo FOREIGN KEY (Query_Id)
        REFERENCES Query_Info (Query_Id),
    CONSTRAINT FK_BlockInfo_BlockQueryInfo FOREIGN KEY (Block_Id)
        REFERENCES Block_Info (Block_Id)
);

/* Created this table to help in data loading */
drop table if exists StagingTable;
CREATE TABLE StagingTable (
    season VARCHAR(100),
    Sector VARCHAR(100),
    Category VARCHAR(100),
    Crop VARCHAR(100),
    QueryType VARCHAR(100),
    QueryText VARCHAR(5000),
    KCCAns VARCHAR(5000),
    StateName VARCHAR(100),
    DistrictName VARCHAR(100),
    BlockName VARCHAR(100),
    CreatedOn VARCHAR(5000)
);

/* Created required views */
drop view if exists location;
CREATE VIEW Location AS
    SELECT DISTINCT
        BI.Block_Id AS Location_Id,
        Block_Name,
        District_Name,
        State_Name
    FROM
        Block_QueryInfo BQI
            JOIN
        Block_Info BI ON BQI.Block_Id = BI.Block_Id
            JOIN
        District_Info DI ON BI.District_Id = DI.District_Id
            JOIN
        State_Info SI ON DI.State_Id = SI.State_Id;

drop view if exists Crop_Details;
CREATE VIEW Crop_Details AS
    SELECT 
        CR.Crop_Id,
        s.Season_Name Season,
        se.Sector_Name Sector,
        c.Category_Name Category,
        cr.Crop_NAme Crop
    FROM
        SEASON S
            JOIN
        SECTOR SE ON S.SEASON_ID = SE.Season_Id
            JOIN
        CATEGORY C ON C.SECTOR_ID = Se.SECTOR_ID
            JOIN
        CROP CR ON CR.CATEGORY_iD = C.CATEGORY_iD
    ORDER BY crop_id;