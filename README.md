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
