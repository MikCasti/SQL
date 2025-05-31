-- Creazione della stored procedure aggiornata
CREATE PROCEDURE ProcedureGestione
    @Output NVARCHAR(MAX), -- Parametro JSON
    @Stagione NVARCHAR(50) -- Parametro stagione
AS
BEGIN
    SET NOCOUNT ON;
    -- Tabella temporanea per l'elaborazione dei dati JSON
    CREATE TABLE #DatiEstratti (
        Personaggio NVARCHAR(100),
        NumeroEpisodio NVARCHAR(50),
        Battuta NVARCHAR(MAX)
    );
    BEGIN TRY
        -- Parsing del JSON ed estrazione dei dati
        INSERT INTO #DatiEstratti (Personaggio, NumeroEpisodio, Battuta)
        SELECT
            JSON_VALUE(a.value, '$.Personaggio') AS Personaggio,
            JSON_VALUE(a.value, '$.NumeroEpisodio') AS NumeroEpisodio,
            JSON_VALUE(a.value, '$.Battuta') AS Battuta
        FROM OPENJSON(@Output) a;
        -- Inserimento nella tabella definitiva
        INSERT INTO Episodi (Stagione, NumeroEpisodio, Personaggio, Battuta)
        SELECT @Stagione, NumeroEpisodio, Personaggio, Battuta
        FROM #DatiEstratti;
        PRINT 'Dati JSON inseriti correttamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Errore durante l''ingestione dei dati JSON.';
        THROW;
    END CATCH;
    -- Pulizia della tabella temporanea
    DROP TABLE #DatiEstratti;
END;
GO