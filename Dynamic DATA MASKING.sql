create user [edoardo.buono@itsincom.it] FROM EXTERNAL PROVIDER


--Dynamic DATA MASKING 

-- salvare i dati in chiaro 
--dinamicamente mostrare o togliere la maschera

create table dbo.users (
id int identity,
PrincipalName varchar(200) not null,
Birthdate date,
login varchar(25),
password nvarchar(30),
eta as datediff(year, Birthdate, getdate())
)
alter table dbo.users 
ADD CONSTRAINT PK_PrincipalName PRIMARY KEY (PrincipalName)

insert into dbo.users(PrincipalName, Birthdate, login, password) VALUES 
('abc.def@itsincom.it','1993-01-03','abcdef','ghi'),
('carlo.rossi@itsincom.it','2003-05-24','Carlros','Pippo99££'),
('mario.monti@itsincom.it','1900-12-01','Mons','Trumpsgotthepower'),
('mariogiordano@itsincom.it','1960-10-15','Bonus','Monopattino!')

select * from dbo.users --vediamo password
select CURRENT_USER
--password non visibile
ALTER TABLE dbo.users
ALTER COLUMN [password] ADD MASKED WITH (FUNCTION = 'partial(0,"********",0)')

--attribuiamo la maschera all'utente corrente 
--GRANT / 
grant UNMASK on dbo.users TO user1
execute as user = 'user1'

select *
FROM dbo.users 
where len(password)<8  --regola sulla lunghezza
	or password not like '%[!"£$%&/()=?^]%'  --regola caratteri speciali
	or password not like '%[a-z]%'
	or password not like '%[0-9]%'

revert

--aggiungere maschera sulla data
ALTER TABLE dbo.users DROP COLUMN eta;

ALTER TABLE dbo.users
ALTER COLUMN [Birthdate] ADD MASKED WITH (FUNCTION = 'datetime("Y")')
--aggiungere maschera sull'id
ALTER TABLE dbo.users
ALTER COLUMN [id] ADD MASKED WITH (FUNCTION = 'default()')

CREATE TABLE dbo.certifications (
	id int identity,
	PrincipalName varchar(200) not null,
	certificate varchar(15),
	dateCertificate date


)

ALTER TABLE dbo.Certifications
ADD CONSTRAINT FK_PrincipalName FOREIGN KEY (PrincipalName) REFERENCES dbo.users(principalName)

ALTER table dbo.users
ALTER COLUMN PrincipalName ADD MASKED WITH (FUNCTION = 'email()')

insert into dbo.certifications values 
('mariogiordano@itsincom.it','PL-300', getdate()),
('mariogiordano@itsincom.it','DP-300', getdate()),
('mariogiordano@itsincom.it','PL-600', getdate())

select * from dbo.users

select * 
from dbo.users U INNER JOIN dbo.certification C
	 ON U.principalName = C.principalName

insert into dbo.certifications(PrincipalName, certificate, dateCertificate)
	select PrincipalName, 'DP-300', getdate()
	from dbo.users

select * from fn_my_permission(NULL, 'database')
revert

GRANT INSERT ON DATABASE::Test_C001 TO user1 WITH GRANT OPTION
