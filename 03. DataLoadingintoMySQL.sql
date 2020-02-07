/***********************************************
** File: 03.DataLoadintoMySQL.sql
** Desc: SQL query for loading data into staging table from csv file
** Auth: Debadutta Dey
** Date: 07/01/2018
************************************************/
use kcc;

LOAD DATA LOCAL INFILE 
'E:/Data Science/Jigshaw Pgpdm/02. Fundamental Of Database/Final Projects/data/Newdata/datafile (5).csv'
    INTO TABLE StagingTable 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



