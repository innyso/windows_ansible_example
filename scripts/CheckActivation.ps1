Param
(
    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    [String[]]$ComputerName = $env:COMPUTERNAME
)

#defined initial data
$LicenseStatus = @("Unlicensed","Licensed","OOB Grace", "OOT Grace","Non-Genuine Grace","Notification","Extended Grace")

$result = Get-CimInstance -ClassName SoftwareLicensingProduct -ComputerName $ComputerName | 
    Where{$_.PartialProductKey -and $_.Name -like "*Windows*"} | 
    Select @{Expression={$LicenseStatus[$($_.LicenseStatus)]}} | 
    format-table -hidetableheaders |
    Out-String
   
return $result.Trim()
