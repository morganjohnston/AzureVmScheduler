workflow StartVMs
{
    param (
        [Parameter(Mandatory=$true)]
        [string[]]
        $VmNames
    )

    # Only start VMs on weekdays
    $day = (Get-Date).DayOfWeek
    if ($day -eq 'Saturday' -or $day -eq 'Sunday'){
        exit
    }
    
    $cred =  Get-AutomationPSCredential -Name "AccountCredentials"
    Add-AzureAccount -Credential $cred
    
    foreach ($name in $VmNames)
    {
        Start-AzureVM -Name $name -ServiceName $name
    }
}