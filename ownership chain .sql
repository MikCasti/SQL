ALTER ROLE db_datareader ADD MEMBER user1; 

select * from fn_my_permissions(NULL, 'database')

select * from dbo.GetNums(1,10)

exec dbo.usp_Calendar '2010-01-01','2010-12-31'

--ownership chain 
SELECT is_db_chaining_on, name FROM sys.databases;

alter role db_data



ALTER ROLE db_owner ADD MEMBER user2