--RLS
select top 10 * from [dbo].[Calendar]
select top 10 * from [dbo].[certifications]
select top 10 * from [dbo].[Nums]
select top 10 * from [dbo].[test]
select top 10 * from [dbo].[users]
select top 10 * from [dbo].[pippo]


--codice di tutto il DB per chi lo ha eliminato
CREATE TABLE [Sales].[Orders](
	[orderid] [int] IDENTITY(1,1x) NOT NULL,
	[custid] [int] NULL,
	[empid] [int] NOT NULL,
	[orderdate] [date] NOT NULL,
	[requireddate] [date] NOT NULL,
	[shippeddate] [date] NULL,
	[shipperid] [int] NOT NULL,
	[freight] [money] NOT NULL,
	[shipname] [nvarchar](40) NOT NULL,
	[shipaddress] [nvarchar](60) NOT NULL,
	[shipcity] [nvarchar](15) NOT NULL,
	[shipregion] [nvarchar](15) NULL,
	[shippostalcode] [nvarchar](10) NULL,
	[shipcountry] [nvarchar](15) NOT NULL,
CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
[orderid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Primary]
) ON [Primary]
GO
 
ALTER TABLE [Sales].[Orders] ADD  CONSTRAINT [DFT_Orders_freight]  DEFAULT ((0)) FOR [freight]
GO


begin tran
select @@TRANCOUNT
update sales.Orders 
set shipregion = null
where shipregion = 'null'

--FATTO: codice di tutto il DB per chi lo ha eliminato 

--codice della sales.orders con tutti i dati da mettere nel db cloud
--SQL Server Linked Server
--CSV
-- BULK COPY PROGRAM 


--ROW LEVEL SECURITY
--OBBIETTIVO: Generare dei coni di visibilità/ coni d'ombra 

CREATE USER Manager		WITHOUT LOGIN 
CREATE USER Employee1	WITHOUT LOGIN 
CREATE USER Employee2	WITHOUT LOGIN 

--user1: verificare se ha il diritto di lettura sulla tabella
--facciamo un test e vediamo se legge


CREATE SCHEMA Security;
GO

CREATE FUNCTION Security.tvf_securitypredicate(@empid AS int)
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS tvf_rlsEMPID
	WHERE concat('user',@Empid) = USER_NAME() OR USER_NAME() = 'dbo';

GO
--attiviamo la policy di sicurezza 
CREATE SECURITY POLICY SalesFilter
ADD FILTER PREDICATE Security.tvf_securitypredicate(empid)
ON Sales.Orders
WITH (STATE = ON);
GO

--verifichiamo se l'user1 è in grado di leggere il risultato 
--della policy di sicurezza

execute as user = 'user1'
select USER_NAME()

GRANT SELECT ON Security.tvf_securitypredicate TO user1

select * from Security.tvf_securitypredicate(1)

revert

select * from sales.orders

--generare un utente per ogni impiegato in modo che legga solo gli ordini suoi 

 CREATE USER user3 WITHOUT LOGIN 
 CREATE USER user4 WITHOUT LOGIN 
 CREATE USER user5 WITHOUT LOGIN 


CREATE FUNCTION dbo.implettura (@empid NVARCHAR(100))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT OrderID, CustomerID, OrderDate, SalesRep
    FROM sales.orders
    WHERE empid = USER_NAME()  
);

CREATE SECURITY POLICY OrderSecurityPolicy
ADD FILTER PREDICATE dbo.implettura(Empid)
ON sales.orders
WITH (STATE = ON);
