<#
 .Synopsis
  Allow a user account to access the docker engine without elevated access rights

 .Description
  The function adds FullControl access rights to the named pipe where the docker engine is listening.

 .Parameter Account
  The account you want to allow access

 .Example
   # allow user "CONTOSO\pmiller" access to the docker engine
   Add-AccountToDockerAccess -Account "CONTOSO\pmiller"
#>

function Add-AccountToDockerAccess {
#Requires -RunAsAdministrator
  param
  (
    [parameter(Mandatory=$true,Position=0)]
    [String[]]
    $Account
  )
    $pre_ErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    $fullControl =[System.Security.AccessControl.FileSystemRights]::FullControl
    $allow =[System.Security.AccessControl.AccessControlType]::Allow

    $pipe_windows = $true
    try {
        $ps = (docker -H npipe:////./pipe/docker_engine_windows ps) | Out-Null
        if ($LASTEXITCODE -ne 0) {
            $pipe_windows = $false
        }
    } catch{
        $pipe_windows = $false
    }

    if (-not $pipe_windows) {
        $pipe_non_windows = $true
        try {
            $ps = (docker -H npipe:////./pipe/docker_engine ps) | Out-Null
            if ($LASTEXITCODE -ne 0) {
                $pipe_non_windows = $false
            }
        } catch{
            $pipe_non_windows = $false
        }
    }

    $ErrorActionPreference = $pre_ErrorActionPreference

    if (-not $pipe_windows -and -not $pipe_non_windows) {
        Write-Host "Unable to reach the Docker engine. Are your sure Docker is running and reachable?"
        return
    }
    
    $npipe = "\\.\pipe\docker_engine"
    if ($pipe_windows) {
     $npipe = "\\.\pipe\docker_engine_windows"
    }

    $dInfo = New-Object "System.IO.DirectoryInfo" -ArgumentList $npipe
    $dSec = $dInfo.GetAccessControl()
    $rule = New-Object "System.Security.AccessControl.FileSystemAccessRule" -ArgumentList $account,$fullControl,$allow
    $dSec.AddAccessRule($rule)
    $dInfo.SetAccessControl($dSec)
}

Export-ModuleMember -Function Add-AccountToDockerAccess
