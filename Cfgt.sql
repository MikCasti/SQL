drop schema cfg

CREATE TABLE cfg.Tableinformation (
id int IDENTITY PRIMARY KEY,
[schema] nvarchar (5),
name nvarchar(20),
databasename nvarchar(25),
)
;

INSERT INTO cfg.Tableinformation ([schema],[name],[databasename])
values	('dbo','dim_Card','Test_C001'),
		('dbo','dim_cash_Type','Test_C001'),
		('dbo','dim_Coffee_name','Test_C001'),
		('dbo','dim_Date','Test_C001'),
		('dbo','dim_Time','Test_C001')
	

	--delete 
	select * from cfg.Tableinformation
	