USE FlightDeckDB;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PipelineData' AND xtype='U')
BEGIN
    CREATE TABLE PipelineData (
        Date DATE,
        Sector VARCHAR(50),
        FlagRate FLOAT,
        FairnessScore FLOAT,
        KPI_Index FLOAT,
        PRIMARY KEY (Date, Sector)
    );
END;

