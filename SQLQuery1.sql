create database ProjectWork   

create table Episodi( 

    Stagione nvarchar(100),

    EpisodioNumero int,

    Personaggio nvarchar(20),

	Battuta nvarchar(max)

);

create  table Personaggio(

PersonaggioID int identity(1,1) primary key,

NomePersonaggio nvarchar(20)

);

create table Stagione(

StagioneID int identity(1,1) primary key,

StagioneN nvarchar(100)

);

create table Episodio(

EpisodioID int identity(1,1) primary key,

StagioneID int foreign key references Stagione(StagioneID),

EpisodioN smallint 

); select * from Episodio where StagioneID=EpisodioN

create table Dialoghi(

StagioneID int foreign key references Stagione(StagioneID),

EpisodioID int foreign key references Episodio(EpisodioID),

PersonaggioID int foreign key references Personaggio(PersonaggioID),

NomePersonaggio nvarchar(20),

Battuta nvarchar(max));
 
insert into Dialoghi (StagioneID,EpisodioID,PersonaggioID,NomePersonaggio,Battuta)

select StagioneID,EpisodioID,PersonaggioID,Personaggio,Battuta

from Episodi
 
select * from Dialoghi

insert into Personaggio(NomePersonaggio)

select distinct Personaggio

from Episodi
 
insert into Stagione(StagioneN)

select distinct Stagione

from Episodi

order by Stagione asc
 
insert into Episodio(StagioneID,EpisodioN)

select distinct StagioneID,EpisodioNumero

from Episodi 

order by StagioneID,EpisodioNumero
 
alter table Episodi

add StagioneID int
 
alter table Episodi

add EpisodioID int
 
alter table Episodi

add PersonaggioID int
 
update Episodi

set PersonaggioID = (select PersonaggioID 

from Personaggio select * from Episodi

where NomePersonaggio=Personaggio)
 
update Episodi 

set EpisodioID=(select top 1 EpisodioID 

from Episodio b

where StagioneID=b.StagioneID and EpisodioNumero=b.EpisodioN) select * from Episodi
 
update Episodi

set StagioneID=(select StagioneID 

from Stagione 

where Stagione=StagioneID)

update Episodi 

set Stagione = case 

					when Stagione= 'DS9' then '1'

					when Stagione= 'ENT' then '2'

					when Stagione= 'TAS' then '3'

					when Stagione= 'TNG' then '4'

					when Stagione= 'TOS' then '5'

					when Stagione= 'VOY' then '6'

                else Stagione 

				end

go
 
--numero totale delle battute dei personaggi per ogni episodio

create view N_Battute as

select Stagione,EpisodioNumero,personaggio,count(Battuta) as NumBat

from Episodi

group by stagione,EpisodioNumero,Personaggio
 
select * from N_Battute order by Stagione,EpisodioNumero,Personaggio
 
 
--numero totale delle parole nelle battute di ogni personaggio

create view N_parole as

select Stagione,EpisodioNumero,Personaggio, sum(len(trim(Battuta))-len(replace(trim(Battuta),' ',''))+1) as Numero_parole

from Episodi

group by Stagione,EpisodioNumero,Personaggio
 
select * from N_parole order by Stagione,EpisodioNumero,Personaggio
 
--lunghezza totale delle battute per personaggio,per ogni stagione e episodio

create view lunghezzaBat as

select Stagione,EpisodioNumero,Personaggio, sum(len(Battuta)) as lunghezzaBat

from Episodi

group by Stagione,EpisodioNumero,Personaggio

select * from lunghezzaBat order by lunghezzaBat desc

--elenco delle stagioni con il loro numero totale di battute relativo

create view Num_Battute_Stagione as

select Stagione,count(*) as numero_battute_stagione

from Episodi

group by Stagione

select * from Num_Battute_Stagione order by Stagione

--battuta più lunga di tutte le stagione

create VIEW battuta_piu_lunga AS

SELECT E.Stagione,E.EpisodioNumero,E.Personaggio,E.Battuta,LEN(E.Battuta) AS lunghezza_battuta

FROM Episodi E

WHERE LEN(E.Battuta) = (

    SELECT MAX(LEN(B.Battuta))

    FROM Episodi B

    WHERE B.Stagione = E.Stagione AND B.EpisodioNumero = E.EpisodioNumero

);
 
select top 10 * from battuta_piu_lunga order by lunghezza_battuta desc
 
--totale battute dette per episodio

create view Tot_Battute_Episodio as 

select Stagione,EpisodioNumero,count(Battuta) as Totale_Battute_Episodio

from Episodi

group by Stagione,EpisodioNumero
 
select * from Tot_Battute_Episodio order by Stagione,EpisodioNumero
 
--media complessiva delle battute dette per episodio

select Stagione,EpisodioNumero,avg(Tot_Bat_Episodio) as Media_battute_episodio 

from Tot_Battute_Episodio 

group by Stagione,EpisodioNumero 

order by Stagione,EpisodioNumero
 
--test store procedure

select * from dbo.Episodi
 
--numero totale dei personaggi per stagione

create view Num_Tot_personaggi_Stagione as

select Stagione,count(distinct(Personaggio)) as NumeroPersonaggi

from Episodi

group by Stagione
 
select * from Num_Tot_personaggi_Stagione order by Stagione asc
 
--numero medio delle battute dette da ogni personaggio per ogni stagione

create view media_battute_stagione as

select Stagione,Personaggio,avg(BattuteTot) as Media_Battute

from
 
(select Stagione, Personaggio,count(Battuta) as BattuteTot 

from Episodi

group by Stagione,Personaggio,EpisodioNumero)as subquery_tot
 
group by Stagione,Personaggio
 
select * from media_battute_stagione order by Stagione,Personaggio
 