workflow StopVMs
{
    param (
        [Parameter(Mandatory=$true)]
        [string[]]
        $VmNames
    )
    
    $cred =  Get-AutomationPSCredential -Name "AccountCredentials"
    Add-AzureAccount -Credential $cred
 
    foreach ($name in $VmNames)
    {
        Stop-AzureVM -Name $name -ServiceName $name -Force
    }
}