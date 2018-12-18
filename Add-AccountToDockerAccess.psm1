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


    $fullControl =[System.Security.AccessControl.FileSystemRights]::FullControl
    $allow =[System.Security.AccessControl.AccessControlType]::Allow

    $npipe = "\\.\pipe\docker_engine"
    $osname = (Get-CimInstance win32_operatingsystem).caption
    if ($osname -like "* Windows 10 *") {
        $npipe = "\\.\pipe\docker_engine_windows"
    }

    $dInfo = New-Object "System.IO.DirectoryInfo" -ArgumentList $npipe
    $dSec = $dInfo.GetAccessControl()
    $rule = New-Object "System.Security.AccessControl.FileSystemAccessRule" -ArgumentList $account,$fullControl,$allow
    $dSec.AddAccessRule($rule)
    $dInfo.SetAccessControl($dSec)
}

Export-ModuleMember -Function Add-AccountToDockerAccess