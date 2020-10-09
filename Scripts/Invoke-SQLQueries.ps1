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
    Function Get-ConnectionString{
        [CmdletBinding()]
        Param(
            # Parameter help description
            [Parameter(Mandatory = $True)]
            $QueryInfo
        )

        "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=$($QueryInfo.DBName);Data Source=$($QueryInfo.SQLServer)\$($Queryinfo.SQLInstance),$($QueryInfo.Port)"
    }
    Function Invoke-SQLQuery {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory =$true)]
        [string]$SQLQuery,
        [Parameter(Mandatory =$true)]
        [string]$ConnectionString

    )



    }
        
    $Start = Get-Date
    Write-Log "Script Started"

}
Process 
{
Write-Log "Working on $QueryInventoryPath"
try {
    $Inventory = Import-PowerShellDataFile -Path $QueryInventoryPath -ErrorAction Stop
    $Message = "Successfully Imported queries from '$QueryInventoryPath'"
}
catch {
    $Message = "Could not import '$QueryInventoryPath'. Error: $($_.Exception.Message)" 
}
finally {
    Write-Log $Message
}
foreach ($QueryInfo in $Inventory.Queries) {

    Write-Log "Executing, QueryFile = '$($QueryInfo.QueryFile)', SQLServer = '$($QueryInfo.SQLServer)', SQLIntance='$($QueryInfo.SQLInstance)', DBName='$($QueryInfo.DBName)', Port='$($QueryInfo.Port)'"
    try {
        
        Invoke-Sqlcmd -Database $($QueryInfo.Database) -ServerInstance "$($QueryInfo.SQLServer)\$($QueryInfo.SQLInstance),$($QueryInfo.Port)" -InputFile $($QueryInfo.QueryFile)
        $Message = "Successully executed query from '$($QueryInfo.QueryFile)' for '$($QueryInfo.SQLServer)\$($QueryInfo.SQLInstance),$($QueryInfo.Port)'"
        
    }
    catch {
        $Message = "Couldnt execute query from file '$($QueryInfo.QueryFile) for '$($QueryInfo.SQLServer)\$($QueryInfo.SQLInstance),$($QueryInfo.Port)''. Error: $($_.Exception.Message)"
    }
    finally {
        Write-Log $Message
        
    }

    }

}

End {

$Duration = [Math]::Round(((Get-Date)  - $Start).TotalSeconds,2)
Write-Log "Script Ended. Duration: $Duration Seconds."
}