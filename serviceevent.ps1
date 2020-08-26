#request service name
$svcName = $args

#set basic event log values
$eventlogvalues= @{
LogName = 'Application' 
Source = 'SvcCheck'
}

#set source
$logFileExists = [System.Diagnostics.EventLog]::SourceExists("SvcCheck");

#if the log source exists, it uses it. if it doesn't, it creates it.
if (-not $logFileExists)
{New-EventLog @eventlogvalues}

function Get-MyService {Get-Service @Args -ErrorAction SilentlyContinue}

if ((Get-MyService -Name $svcName  ))

{
#set detailed event values
$infoEntry = @{
EntryType = "Information"
EventID = 816
Message = "The queried service is installed as $svcName"}

#write to event
Write-EventLog @eventlogvalues @infoentry
}

else
{
$errorEntry = @{
EntryType = "Error"
EventID = 818
Message = "We cannot find the specified service as $svcName"}

Write-EventLog @eventlogvalues @errorentry
}
