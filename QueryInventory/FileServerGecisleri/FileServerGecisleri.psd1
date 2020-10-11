@{
    RootFolder = 'C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri'
    Queries = @(
        @{QueryFile = 'Query1.sql';SQLServer='emreg-sql.contoso.com';SQLInstance ='MSSQLSERVER';DBName ='DSC';Port=1433},
        @{QueryFile = 'Query2.sql';SQLServer='emreg-sql.contoso.com';SQLInstance ='I1';DBName ='AdventureWorks2017';Port=50295}
    )
}