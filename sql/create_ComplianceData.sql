USE FlightDeckDB;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ComplianceData' AND xtype='U')
BEGIN
    CREATE TABLE ComplianceData (
        Date DATE,
        Region VARCHAR(50),
        ComplianceScore FLOAT,
        RiskFlag BIT,
        PRIMARY KEY (Date, Region)
    );
END;

