USE Test_C001
create table sales.test2 (id int, colore varchar(15))

--controllare che diritti ha un utente

--sistema per testare la funzionalità dell'utenza
--senza dover effettuare l'accesso esplicito 

execute as user = 'user2'

select user_name()

create table sales.pippo (id int, testo varchar(15))
select * from fn_my_permissions(null, 'database')

--permette di tornare indietro 
revert 

--autorizzare utenza itsincom.it
edoardo.buono@itsincom.it

create user [edoardo.buono@itsincom.it] FROM EXTERNAL PROVIDER



