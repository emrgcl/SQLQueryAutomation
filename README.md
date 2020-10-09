# SQLQueryAutomation

## Requirements 
- Specify the full path to the SQL Query file. Spaces are not allowed in the file path or file name.
- SQLServer Module
## Samples

- Below is an oledby connection source 
    ```
    [oledb]
    ; Everything after this line is an OLE DB initstring
    Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Data Source=emreg-sql\I1,50295
    ```

- Sample Powershell Script for OLEDB Connection
    ```PowerShell
    ##############################################################################
    ##
    ## Test_Connection_String.ps1
    ##
    ## This script tries to establish a DB connection as instructed by a given
    ## Connection String, then execute the given SQL query and save the result to
    ## out.csv file
    ##
    ##############################################################################
    ## Please provide Connection String
    $ConnectionString = "Connection String to be tested"
    ## Please provide SQL Query
    $SQLquery = "SQL query to be tested"
    ##############################################################################
    $conn = New-Object System.Data.OleDb.OleDbConnection
    $conn.ConnectionString = $ConnectionString
    $comm = New-Object System.Data.OleDb.OleDbCommand($SQLquery,$conn)
    $conn.Open()
    $adapter = New-Object System.Data.OleDb.OleDbDataAdapter $comm
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet)
    $conn.Close()
    $table = $dataset.Tables[0]
    $table | Export-CSV "out.csv"
    ```