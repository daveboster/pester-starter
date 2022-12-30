$ModuleToImport = "AWSPowerShell.NetCore"
$MinimumVersion = "4.0"

Write-Debug "Importing $ModuleToImport Module"
$powerShellModule = Get-Module -Name $ModuleToImport -ListAvailable
if (!$powerShellModule) {
    try {
        Install-Module -Name $ModuleToImport -Scope CurrentUser -Force -MinimumVersion $MinimumVersion  #-SkipPublisherCheck
        $powerShellModule = Get-Module -Name $ModuleToImport -ListAvailable
    }
    catch {
        Write-Error "Failed to install the $ModuleToImport module. $($PSItem.Exception.Message)" -ErrorAction Stop
    }
}
Write-Host "$ModuleToImport version: $($powerShellModule.Version.Major).$($powerShellModule.Version.Minor).$($powerShellModule.Version.Build)"
$powerShellModule | Import-Module