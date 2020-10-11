# SQLQueryAutomation

## Requirements 
- Specify the full path to the SQL Query file. Spaces are not allowed in the file path or file name.
- SQLServer Module

## How to Setup

Highlevel Steps;
- **Create Configuration files** - .psd1 (powershell data file) incuding query configuraiton (db, instance port etc)
- **Crete RootFolder Structure**  and cpy the psd1 file cretaed above along with the query files set in this psd1 file
- **Run the script**



### Create Configuration files

```PowerShell
@{
    RootFolder = 'C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri'
    Queries = @(
        @{QueryFile = 'Query3.sql';SQLServer='emreg-sql.contoso.com';SQLInstance ='MSSQLSERVER';DBName ='OperationsManager';Port=1433},
        @{QueryFile = 'Query4.sql';SQLServer='emreg-sql.contoso.com';SQLInstance ='MSSQLSERVER';DBName ='OperationsManagerDW';Port=50295}
    )
}
```

### Crete RootFolder Structure
Create folders per .psd1 file and put query files in these root folders.
The hastable files including the configuration (query inventory) should exist in a folder along with the query files like below.
```
├───QueryInventory
│   ├───AdobeGecisleri
│   │       AdobeGecisleri.psd1
│   │       Query3.sql
│   │       Query4.sql
│   │
│   └───FileServerGecisleri
│           FileServerGecisleri.psd1
│           Query1.sql
│           Query2.sql
│
└───Scripts
        Invoke-SQLQueries.ps1
        Log.txt
```` 
### Run the script

```PowerShell
 .\Invoke-SQLQueries.ps1 -QueryInventoryPath 'C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\FileServerGecisleri.psd1','C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\AdobeGecisleri.psd1' -LogFilePath C:\Temp\Log11.txt -Verbose
```


