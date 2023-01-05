$ModuleToImport = "Pester"
$MinimumVersion = "5.3"

Write-Debug "Importing $ModuleToImport Module"
$powerShellModule = Get-Module -Name $ModuleToImport -ListAvailable | Where-Object { $_.Version -ge $MinimumVersion }
if (!$powerShellModule) {
    try {
        Install-Module -Name $ModuleToImport -Scope CurrentUser -MinimumVersion $MinimumVersion -Force -SkipPublisherCheck
        $powerShellModule = Get-Module -Name $ModuleToImport -ListAvailable | Where-Object { $_.Version -ge $MinimumVersion }
    }
    catch {
        Write-Error "Failed to install the $ModuleToImport module" -ErrorAction Stop
        throw
    }
}
Write-Host "$ModuleToImport version: $($powerShellModule.Version.Major).$($powerShellModule.Version.Minor).$($powerShellModule.Version.Build)"
$powerShellModule | Import-Module
