# dockeraccesshelper

PowerShell module that allows access to the Docker engine. Install it using 

```
Install-Module -Name dockeraccesshelper
```

After that import it and use it to give access to any user

```
PS C:\Windows\system32> Import-Module dockeraccesshelper
PS C:\Windows\system32> Add-AccountToDockerAccess "CONTOSO\PMILLER"
```

For more details see https://www.axians-infoma.com/techblog/allow-access-to-the-docker-engine-without-admin-rights-on-windows/


## Manually runing commands in case Import-Module is not preferred 

```
$account="<DOMAIN>\<USERNAME>"
$npipe = "\\.\pipe\docker_engine"                                                                                 
$dInfo = New-Object "System.IO.DirectoryInfo" -ArgumentList $npipe                                               
$dSec = $dInfo.GetAccessControl()                                                                                 
$fullControl =[System.Security.AccessControl.FileSystemRights]::FullControl                                       
$allow =[System.Security.AccessControl.AccessControlType]::Allow                                                  
$rule = New-Object "System.Security.AccessControl.FileSystemAccessRule" -ArgumentList $account,$fullControl,$allow
$dSec.AddAccessRule($rule)                                                                                        
$dInfo.SetAccessControl($dSec)
```

## If running PowerShell 7 or newer
Newer versions of PowerShell do not support the classes/methods currently used by `dockeraccesshelper`. If you face errors like `Method invocation failed because [System.IO.DirectoryInfo] does not contain a method named 'GetAccessControl'.`, you can work around this by:
- temporarily switch to PowerShell 5.1 (or earlier)
- use PowerShell ISE to execute the manual commands
