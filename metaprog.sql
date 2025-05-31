USE [Test_C001]
GO

/****** Object:  UserDefinedFunction [dbo].[GetNums]    Script Date: 04/02/2025 10:22:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetNums](@low AS BIGINT, @high AS BIGINT) RETURNS TABLE
AS
RETURN
  WITH
    L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)),
    L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
    L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
    L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
    L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
    L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
    Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
             FROM L5)
  SELECT TOP(@high - @low + 1) @low + rownum - 1 AS n
  FROM Nums
  ORDER BY rownum;
GO

--generare la tabella dei numeri da 1 a 100k 
--generare la tabella del calendario (una riga= un giorno) per gli anni 2010-2030


select N
into dbo.Nums
from dbo.GetNums(1,100000)


declare @inizio date = '2010-01-01', @fine date = '2040-12-31'

exec dbo.usp_Calendar @inizio, @fine

alter procedure dbo.usp_Calendar @inizio date, @fine date
as
	IF OBJECT_ID('dbo.Calendar', 'u' ) is not null 
	BEGIN
		-- svuotare la tabella del calendario
		truncate table dbo.Calendar
 
		-- popolare la tabella del calendario
		insert into dbo.Calendar
			select * 
			from dbo.utf_generateCalendar(@inizio, @fine)
	END
	ELSE
	BEGIN
		select * 
		into dbo.Calendar
		from dbo.utf_generateCalendar(@inizio, @fine)
	END;
	

	

select * 
into dbo.Calendar
from dbo.utf_generateCalendar(@inizio,@fine)



create function dbo.utf_generatecalendar(@inizio date, @fine date)
returns table as 
return 
SELECT 
		n,
		convert( date, DATEADD(DAY,  n-1, @inizio) ) as Data,
		day(DATEADD(DAY,  n-1, @inizio)) as Giorno,
		month(DATEADD(DAY,  n-1, @inizio)) as Mese,
		year(DATEADD(DAY,  n-1, @inizio)) AS Anno,
		datename(weekday, DATEADD(DAY,  n-1, @inizio)) as GiornoSettimana,
		format (DATEADD(DAY,  n-1, @inizio), 'yyyy-MMM') as AnnoMese,
		EOMONTH (DATEADD(DAY,  n-1, @inizio))as UltimoGiornoMese
from dbo.nums
where  DATEADD(DAY,  n-1, @inizio) <= @fine

select	count(*), 
		count(distinct data), 
		min(data),
		max(data)
 from dbo.Calendar


 --quale versione stiamo usando?
 select @@VERSION

 --compatibility level 

 --processo di migrazione: 
 --db on-prem (120) -> DB on-cloud(120) -> capire se è possibile alzare il livello 
 
 --METAPROGRAMMAZIONE
 declare @code varchar(max) = 'select * from dbo.Calendar'

 exec(@code) 
	 --mostrare per ogni tabella presenti nel db quante righe sono salvate

	declare @tablename varchar(max) = 'dbo.Calendar'
			,@queryBase varchar(max) = 'select count(*) from '
			,@query varchar(max) =  ''

	exec(@queryBase+@tablename)

	--Quali sono le tabelle nello schema scelto? 'dbo'
	select name as Tablename
			,SCHEMA_NAME(schema_id) as SchemaName

	from sys.all_objects
	where type = 'u' and object_id > 0 

-- quali sono le tabelle nello schema scelto? 'dbo'
create procedure util.usp_RowNumberTables as 
--+ per concatenarli, 3 apici per non fare casino col codice
declare  @query varchar(max) = ''
 
-- quali sono le tabelle nello schema scelto? 'dbo'

select 
	@query = 
	string_agg('select 
	  ''' + SCHEMA_NAME(schema_id) + ''' as SchemaName
	, ''' + name + ''' as TableName ' 
	+',count(*) as RowNumber FROM '
	+SCHEMA_NAME(schema_id)
	+'.'
	+name
	,' UNION ALL ')
--informazioni alle tabelle disponibili nel database
from sys.all_objects
where type = 'u'  and object_id > 0
 
exec(@query)
exec util.usp_RowNumberTables

--METAPROG: -> SQL Injection

--creare una tabella con 2 colonne dbo.test(id,int, colore varchar(15))
declare  @query varchar(max) = 'select * from dbo.Nums where n<'
		,@param varchar(max) = '15; create table dbo.test(id int,colore varchar(15))'

		select try_convert(int,@param)
		print(@query+@param)


--https://www.porini.it/database/@param = ''create table dbo.test(id,int, colore varchar(15))


--creazione delle utenze 
--connessione al SERVER (quello in cui sono registrati gli utenti) --> LOGIN 
--connessione al database (quello in cui sono registrati gli utenti)  --> USERNAME
--login, username, password, permessi

create login user1 with password = 'Pippo88$$'	

CREATE USER user1 FROM LOGIN user1

GRANT EXECUTE ON OBJECT :: dbo.usp_Calendar TO User1;

exec dbo.usp_Calendar '2010-01-01','2010-12-31'
--permessi di lettura di tutto il database





--RLS, Dynamic data Masking

-- generare un utente user2 che abbia accesso al master e al test_c001

-- che possa fare quello che vuole sotto lo schema "sales"


USE Test_C001
ALTER ROLE db_datawriter ADD MEMBER USER2; -- Ensure you're in the correct database context
alter LOGIN user2 WITH PASSWORD = 'Pippo77$$';
CREATE USER user2 FOR LOGIN user2;
ALTER ROLE db_datawriter ADD MEMBER user2;
create schema sales

GRANT CONTROL ON SCHEMA :: sales TO user2

ALTER ROLE db_owner ADD MEMBER user2


execute as user = 'user2'

select user_name()

revert 



