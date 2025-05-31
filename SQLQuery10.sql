Create view vw_customer as(
select 

 c.[FirstName] 		as	[firstName]
,c.[LastName] 		as	[lastName] 
,c.[Company] 		as	[company] 
,c.[Address] 		as	[address]
,c.[City] 			as	[city] 
,c.[Country]		as	[country] 
,c.[PostalCode] 	as	[postalCode]
,c.[Phone] 			as	[phone] 
,c.[Fax] 			as	[fax] 
,c.[Email]			as	[email] 



from dbo.Customer c


)


create view vw_address as 
select
 i.[BillingAddress]		as [address] 
,i.[BillingCity] 		as [city]
,i.[BillingState] 		as [state] 
,i.[BillingCountry] 	as [country]
,i.[BillingPostalCode]	as [postalCode]
from(select distinct [BillingAddress],[BillingCity],[BillingState],[BillingCountry],[BillingPostalCode]
	from dbo.invoice) as i

create view vw_track as(
select 
 t.[Name]		   as	[name]		 
,a.[Title]         as 	[title] 		 
,ar.[Name]          as 	[nameArtist]  
,t.[Composer]      as 	[composer] 	 
,t.[Milliseconds]  as 	[milliseconds]
,t.[UnitPrice]     as 	[unitPrice] 	 
   
from dbo.track t

left join dbo.Album a on t.AlbumId=a.AlbumId
left join dbo.Artist as ar on a.ArtistId=ar.ArtistId
)

CREATE VIEW vw_Date AS
SELECT 
    I.[InvoiceDate] AS [date],
    FORMAT(CAST(I.[InvoiceDate] AS DATE), 'yyyyMMdd') AS ID,
    YEAR(I.[InvoiceDate]) AS [year],
    MONTH(I.[InvoiceDate]) AS [MONTH],
    DAY(I.[InvoiceDate]) AS [DAY],
    DATENAME(WEEKDAY, I.[InvoiceDate]) AS [WEEKDAY]
FROM dbo.Invoice AS I;


