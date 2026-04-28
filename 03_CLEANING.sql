 1. Removing Nulls
DELETE FROM Telecom_Data WHERE Customer_ID IS NULL;
UPDATE Telecom_Data SET Region = 'Unknown' WHERE Region IS NULL;
UPDATE Telecom_Data SET Data_Usage_GB = 0 WHERE Data_Usage_GB IS NULL;

2. Removing Duplicates
WITH DuplicateCTE AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY Transaction_ID, Customer_ID, Call_Date 
        ORDER BY Transaction_ID
    ) AS row_num
    FROM Telecom_Data )

DELETE FROM DuplicateCTE WHERE row_num > 1;

3. Standardization
UPDATE Telecom_Data SET Plan_Type = UPPER(TRIM(Plan_Type));
UPDATE Telecom_Data SET Phone_Number = REPLACE(REPLACE(Phone_Number, '-', ''), ' ', '');

 4. Outlier Removal
DELETE FROM Telecom_Data WHERE Call_Duration_Min < 0 OR Call_Duration_Min > 1440;

5. Feature Engineering
ALTER TABLE Telecom_Data ADD User_Segment VARCHAR(20);
UPDATE Telecom_Data
SET User_Segment = CASE 
    WHEN Data_Usage_GB > 100 THEN 'High Data User'
    WHEN Data_Usage_GB BETWEEN 30 AND 100 THEN 'Mid Data User'
    ELSE 'Low Data User' 
END;
