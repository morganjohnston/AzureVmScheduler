Param(
  [string]$subscriptionId = $(throw "-subscriptionId is required. Get this from the Azure portal."),
  [object[]]$vmNames = $(throw "-vmNames is required. It requires a comma separated list of VM name strings."),
  [int]$startHour = 7,
  [int]$stopHour = 19
)


$startTime = [DateTime]::Now.Date.AddDays(1).AddHours($startHour) #Start scheduling tomorrow so that we don't hit issues when the scheduled start is after the start time.
$stopTime = [DateTime]::Now.Date.AddDays(1).AddHours($stopHour)


Write-Host "Start Time "+$startTime
Write-Host "Stop Time "+$stopTime

Add-AzureAccount
Select-AzureSubscription -SubscriptionId $subscriptionId -Current

#Create automation account
New-AzureAutomationAccount -Location "Southeast Asia" -Name "VmAutomation"
Write-Host "Created automation account..."

#Create automation credential
$cred = Get-Credential
New-AzureAutomationCredential -AutomationAccountName VmAutomation -Name AccountCredentials -Value $cred
Write-Output "Created automation credential..."

#Start VM
New-AzureAutomationSchedule -AutomationAccountName VmAutomation -DayInterval 1 -Name "Start of Day" -StartTime $startTime
New-AzureAutomationRunbook -AutomationAccountName VmAutomation -Path "StartVms.ps1" | Publish-AzureAutomationRunbook
Register-AzureAutomationScheduledRunbook -AutomationAccountName VmAutomation -RunbookName StartVMs -ScheduleName "Start of Day" -Parameters @{"VmNames"=$vmNames}
Write-Host "Registered start runbook..."

#Stop VM
New-AzureAutomationSchedule -AutomationAccountName VmAutomation -DayInterval 1 -Name "End of Day" -StartTime $stopTime
New-AzureAutomationRunbook -AutomationAccountName VmAutomation -Path "StopVms.ps1" | Publish-AzureAutomationRunbook
Register-AzureAutomationScheduledRunbook -AutomationAccountName VmAutomation -RunbookName StopVMs -ScheduleName "End of Day" -Parameters @{"VmNames"=$vmNames}
Write-Host "Registered stop runbook..."
Write-Host "....Azure VM Scheduling Complete..."
