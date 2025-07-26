USE FlightDeckDB;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='NonprofitData' AND xtype='U')
BEGIN
    CREATE TABLE NonprofitData (
        Date DATE,
        Sector VARCHAR(50),
        EngagementLevel FLOAT,
        TransparencyScore FLOAT,
        PRIMARY KEY (Date, Sector)
    );
END;
