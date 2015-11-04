Azure Virtual Machine Scheduler
=

This handy powershell script will create an Azure Automation account and schedule start and stop jobs at given times on weekdays for your Azure Virtual Machines.

Example usage:
```.\AzureVmScheduler.ps1 -subscriptionId "your-sweet-subscription-guid" -vmName "myfirstvm","mysecondvm" -startHour 7 -stopHour 19```

You will then need to authenticate against your Azure subscription and also provide credentials to use for the starting and stopping of the VM.
