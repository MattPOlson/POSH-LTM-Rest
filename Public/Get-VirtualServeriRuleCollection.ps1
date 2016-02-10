﻿Function Get-VirtualServeriRuleCollection {
<#
.SYNOPSIS
    Get the iRules currently applied to the specified virtual server   
.NOTES
    This function defaults to the /Common partition
#>
    param(
        [Parameter(Mandatory=$true)]$F5session,
        [Parameter(Mandatory=$true)]$VirtualServer
    )
    $Partition = 'Common'
    if ($VirtualServer -match '^[/\\](?<Partition>[^/\\]*)[/\\](?<Name>[^/\\]*)$') {
        $Partition = $matches['Partition']
        $VirtualServer = $matches['Name']
    }
    $VirtualServerURI = $F5session.BaseURL + "virtual/~$Partition~$VirtualServer/"

    Try {
        $VirtualserverObject = Invoke-RestMethodOverride -Method Get -Uri $VirtualServerURI -Credential $F5session.Credential
    }
    Catch {
        Write-Error "Failed to get the list of iRules for the $VirtualServer virtual server."
        Write-Error ("StatusCode:" + $_.Exception.Response.StatusCode.value__)
        Write-Error ("StatusDescription:" + $_.Exception.Response.StatusDescription)
        return $false
    }

    #Filter the content for just the iRules
    $VirtualserverObjectContent = $VirtualserverObject | Select-Object -Property rules

    $iRules = $VirtualserverObjectContent.rules

    #If the existing iRules collection is not an array, then convert it to one before returning
    If ($iRules -isnot [system.array]){
        $iRulesArray = @()
        $iRulesArray += $iRules
    }
    Else {
        $iRulesArray = $iRules
    }

    $iRulesArray
}