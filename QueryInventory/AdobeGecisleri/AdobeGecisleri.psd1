@{
    RootFolder = 'C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri'
    Queries = @(
        @{QueryFile = 'Query3.sql';SQLServer='emreg-sql.contoso.com';SQLInstance ='MSSQLSERVER';DBName ='OperationsManager';Port=1433},
        @{QueryFile = 'Query4.sql';SQLServer='emreg-sql.contoso.com';SQLInstance ='MSSQLSERVER';DBName ='OperationsManagerDW';Port=50295}
    )
}