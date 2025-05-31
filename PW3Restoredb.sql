create schema cfg

DROP TABLE IF EXISTS cfg.RestoreDBCampus;
GO

CREATE TABLE cfg.RestoreDBCampus (
    id INT IDENTITY PRIMARY KEY,
    schemaName NVARCHAR(5),
    tableName NVARCHAR(50),             
    databasename NVARCHAR(50),      
    stg_table NVARCHAR(50),          
    dwh_table NVARCHAR(50)           
);


INSERT INTO cfg.RestoreDBCampus (schemaName, tableName, [databasename], [stg_table], [dwh_table])
VALUES 
    ('dbo', 'Building', 'Lezioni3', 'stg_Building', 'dwh_Building'),
    ('dbo', 'Group', 'Lezioni3', 'stg_Group', 'dwh_Group'),
    ('dbo', 'Log', 'Lezioni3', 'stg_Log', 'dwh_Log');



SELECT * FROM cfg.RestoreDBCampus



