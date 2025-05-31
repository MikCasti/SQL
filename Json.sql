exec

alter procedure dbo.
	@stringa varchar(15),
	@nome varchar(15),
	@data date
	as print ('Hello World')

exec dbo.sp_print 'pippo', '', '20250116'

--tabella temporanea 

create table #t (
	id int identity,
	nome varchar(50),
	dataNascita date

)

select * from #t

alter procedure dbo.sp_insertValues 
	@nome varchar(50),
	@data date 
as 
	insert into #t values (@nome,@dataNascita)

exec dbo.sp_insertValues 'pluto', '2025-01-16'

select * from #t

--set operation 
select top 1 * from sales.Orders
union --all 
select top 1 * from sales.Orders

--chi sono i clienti che hanno fatto ordini nel 2015 ma non nel 2016

--ordini 2015 ma non 2016
select custid from sales.orders
where year(orderdate) = 2015 
except--intersect 
select custid from sales.orders
where year(orderdate) = 2016

select 
	custid,
	min(orderdate) as DataIniziale,
	max(orderdate) as Datafinale
from sales.orders
where custid in (21,23,33,36,43,51,85)
group by custid

select custid from sales.orders
where year(orderdate) = 2015 
except--intersect 
select custid from sales.orders
where year(orderdate) = 2016 
select custid 
from sales.orders
where year(orderdate) = 2015  
except
select custid 
from sales.orders 
where year(orderdate) = 2016

--non hanno fatto ordini 
select custid from sales.Customers
except 
select custid from sales.orders

--mostra i clienti che hanno fatto ordini nel 2016 ma non nel 2014
select custid 
from sales.orders 
where year(orderdate) = 2016 
except 
select custid 
from sales.orders 
where year(orderdate) = 2014;

--verifica
SELECT DISTINCT o2016.custid
FROM sales.orders as o2016
LEFT JOIN sales.orders as o2014
  ON o2016.custid = o2014.custid AND YEAR(o2014.orderdate) = 2014
WHERE YEAR(o2016.orderdate) = 2016
  AND o2014.custid IS NULL;

--gli altri 12
select custid from sales.Customers
except(
select custid from sales.orders
where year(orderdate) = 2015 
intersect 
select custid from sales.orders
where year(orderdate) = 2016)

--tabella dei numeri

SELECT n FROM numeri;
WITH ctenumeri AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numeri
    WHERE n < 100000
)
SELECT n FROM ctenumeri
OPTION (MAXRECURSION 0);  


-- modalità non ricorsiva 

with cte0 as 
(
	select 1 as n
	union all 
	select 1
),
cte1 as (select tt.n from cte0 cross join cte0 as tt),
cte2 as (select tt.n from cte1 cross join cte1 as tt),
cte3 as (select tt.n from cte2 cross join cte2 as tt),
cte4 as (select tt.n from cte3 cross join cte3 as tt),
cte5 as (select tt.n from cte4 cross join cte4 as tt)

select top 1000000 
ROW_NUMBER() over(order by n) as nums 
from cte5

--nel caso ricorsivo ci abbiamo impiegato 25 sec, adesso 7 sec. quant'è il miglioramento in pct?

select 25.0/7*100

create schema j
 
create table j.rawJSON (
id int identity,
json NVARCHAR(MAX)
)

DECLARE @J NVARCHAR(MAX) = '{"nome": "Matteo", "età" : "28", "animali": [{"specie" : "Gatto", "Nome" : "Bobitza"},
																		{"specie" : "Criceto", "Nome" : "Yuri"}]}'

INSERT INTO j.rawJSON VALUES (@J)

alter VIEW j.animali as 
	select id, 
		ISJSON(json) AS verifica,
		JSON_VALUE(json, '$.nome') AS nome,
		JSON_VALUE(json, '$."età"') AS età,
		--JSON_VALUE(json, '$.animali') as animali,
		--JSON_QUERY(json, '$.animali') as animali,
		--JSON_VALUE(json, '$.animali[0].specie') as specieAnimale,
		--JSON_VALUE(json, '$.animali[0].nome') as nomeAnimale,
		--R.*,
		JSON_VALUE(R.value, '$.specie') as specieAnimale,
		JSON_VALUE(R.value, '$.nome') as nomeAnimale
	from j.rawJSON
		cross apply openjson(JSON_QUERY(json, '$.animali')) as R

select * from j.rawJSON
select * from j.animali

alter table j.rawJSON
	add età as JSON_VALUE(json, '$."età"')  
	add   int


JSON_VALUE(json, '$.nome') AS nome,
		JSON_VALUE(json, '$."età"') AS età


select * from openrowset(
	bulk ''