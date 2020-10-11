<#
.SYNOPSIS
    Script to execute SQL queries automated for application migration operations. 
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\Repos\SQLQueryAutomation\Scripts> .\Invoke-SQLQueries.ps1 -QueryInventoryPath 'C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\FileServerGecisleri.psd1','C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\AdobeGecisleri.psd1' -LogFilePath C:\Temp\Log11.txt -Verbose
    
    VERBOSE: [10/11/2020 5:47:04 PM][Invoke-SQLQueries.ps1] Script Started
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Working on C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\FileServerGecisleri.psd1 
    C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\AdobeGecisleri.psd1
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Successfully Imported queries from 'C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\FileServerGecisleri.psd1'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Executing, QueryFile = 'Query1.sql', SQLServer = 'emreg-sql.contoso.com', SQLIntance='MSSQLSERVER', DBName='DSC', Port='1433'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Successully executed query from 'C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\Query1.sql' for 
    'emreg-sql.contoso.com\MSSQLSERVER,1433'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Executing, QueryFile = 'Query2.sql', SQLServer = 'emreg-sql.contoso.com', SQLIntance='I1', DBName='AdventureWorks2017', Port='50295'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Couldnt execute query from file 'C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\Query2.sql for 
    'emreg-sql.contoso.com\I1,50295''. Error: Invalid column name 'BusinessEntityI'. 
    Msg 207, Level 16, State 1, Procedure , Line 1.
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Working on C:\Repos\SQLQueryAutomation\QueryInventory\FileServerGecisleri\FileServerGecisleri.psd1 
    C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\AdobeGecisleri.psd1
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Successfully Imported queries from 'C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\AdobeGecisleri.psd1'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Executing, QueryFile = 'Query3.sql', SQLServer = 'emreg-sql.contoso.com', SQLIntance='MSSQLSERVER', DBName='OperationsManager', Port='1433'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Successully executed query from 'C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\Query3.sql' for 
    'emreg-sql.contoso.com\MSSQLSERVER,1433'
    VERBOSE: [10/11/2020 5:47:05 PM][Invoke-SQLQueries.ps1] Executing, QueryFile = 'Query4.sql', SQLServer = 'emreg-sql.contoso.com', SQLIntance='MSSQLSERVER', DBName='OperationsManagerDW', 
    Port='50295'
    VERBOSE: [10/11/2020 5:47:15 PM][Invoke-SQLQueries.ps1] Couldnt execute query from file 'C:\Repos\SQLQueryAutomation\QueryInventory\AdobeGecisleri\Query4.sql for 
    'emreg-sql.contoso.com\MSSQLSERVER,50295''. Error: Cannot open database "OperationsManagerDW" requested by the login. The login failed.
    Login failed for user 'CONTOSO\Emre'.
    VERBOSE: [10/11/2020 5:47:15 PM][Invoke-SQLQueries.ps1] Script Ended. Duration: 10.3 Seconds.
#>
[CmdletBinding()]
Param(
    [Parameter(ValueFromPipeLine=$true)]
    [string[]]$QueryInventoryPath,
    $LogFilePath = "$env:TEMP"

)

Begin {
    #Requires -Modules @{ModuleName= 'SqlServer' ; ModuleVersion='21.1.18080'}
    Function Write-Log {

        [CmdletBinding()]
        Param(
        
        
        [Parameter(Mandatory = $True)]
        [string]$Message,
        [string]$LogFilePath = "$env:TEMP"
        
        )
        
        $LogFilePath = if ($Script:LogFilePath) {$Script:LogFilePath}
        
        $Log = "[$(Get-Date -Format G)][$((Get-PSCallStack)[1].Command)] $Message"
        
        Write-verbose $Log
        $Log | Out-File -FilePath $LogFilePath -Append -Force
        

    }

        
    $Start = Get-Date
    Write-Log "Script Started"

}
Process 
{ 
    Foreach ($InventoryPath in $QueryInventoryPath) {


    Write-Log "Working on $QueryInventoryPath"
    try {
    $Inventory = Import-PowerShellDataFile -Path $InventoryPath -ErrorAction Stop
    $Message = "Successfully Imported queries from '$InventoryPath'"
    }
    catch {
    $Message = "Could not import '$InventoryPath'. Error: $($_.Exception.Message)" 
    }
    finally {
    Write-Log $Message
    }
    
    foreach ($QueryInfo in $Inventory.Queries) {

    Write-Log "Executing, QueryFile = '$($QueryInfo.QueryFile)', SQLServer = '$($QueryInfo.SQLServer)', SQLIntance='$($QueryInfo.SQLInstance)', DBName='$($QueryInfo.DBName)', Port='$($QueryInfo.Port)'"
    try {
        
        Invoke-Sqlcmd -Database $QueryInfo.DBname -ServerInstance "$($QueryInfo.SQLServer)\$($QueryInfo.SQLInstance),$($QueryInfo.Port)" -InputFile "$($Inventory.RootFolder)\$($QueryInfo.QueryFile)" -ErrorAction stop | Out-Null
        $Message = "Successully executed query from '$($Inventory.RootFolder)\$($QueryInfo.QueryFile)' for '$($QueryInfo.SQLServer)\$($QueryInfo.SQLInstance),$($QueryInfo.Port)'"
        
    }
    catch {
        $Message = "Couldnt execute query from file '$($Inventory.RootFolder)\$($QueryInfo.QueryFile) for '$($QueryInfo.SQLServer)\$($QueryInfo.SQLInstance),$($QueryInfo.Port)''. Error: $($_.Exception.Message)"
    }
    finally {
        Write-Log $Message
        
    }

    }

}
}

End {

    $Duration = [Math]::Round(((Get-Date)  - $Start).TotalSeconds,2)
    Write-Log "Script Ended. Duration: $Duration Seconds."
}