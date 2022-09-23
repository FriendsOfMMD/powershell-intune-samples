$module = Get-Module -Name Microsoft.Graph.Intune
if (-not $module)
{
    Install-Module NuGet -Force
    Install-Module Microsoft.Graph.Intune
}
Import-Module Microsoft.Graph.Intune -Global

Connect-MSGraph


$FolderPath = "c:\temp\"
    

$deviceManagementScripts = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts"                               

$scriptDetails = $deviceManagementScripts.value | Select-Object id, displayname, filename

foreach($dmscript in $scriptDetails){
            $script = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts/$($dmscript.id)" -HttpMethod GET
            [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($($script.scriptContent))) | Out-File -Encoding ASCII -FilePath $(Join-Path $FolderPath $($script.fileName))
        }

       $scriptDetails | Out-File C:\temp\log.txt