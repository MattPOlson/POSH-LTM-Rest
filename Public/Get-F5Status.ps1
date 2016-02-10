﻿Function Get-F5Status{
<#
.SYNOPSIS                                                                          
    Test whether the specified F5 is currently in active or standby failover mode
#>
    param (
        [Parameter(Mandatory=$true)]$F5session
    )

    $FailoverPage = $F5Session.BaseURL -replace "/ltm/", "/cm/failover-status"

    $FailoverJSON = Invoke-RestMethodOverride -Method Get -Uri $FailoverPage -Credential $F5Session.Credential

    #This is where the failover status is indicated
    $FailOverStatus = $FailoverJSON.entries.'https://localhost/mgmt/tm/cm/failover-status/0'.nestedStats.entries.status.description

    #Return the failover status value
    $FailOverStatus

}