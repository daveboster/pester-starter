<#
.SYNOPSIS
  Tests for AWS credentials
#>

param (
  # AWS Credential Profile Name to pass to AWS-PowerShell
  [Parameter(Mandatory=$false)]
  [string]
  $ProfileName,

  # AWS Region to pass to AWS-PowerShell
  # Related to Pester Tag 'Allowed'
  [Parameter(Mandatory=$false)]
  [string] $Region,

  # Skip All Pester Tests
  # Can be useful when trying to validate test changes.
  [Parameter(Mandatory=$false)]
  [switch] $Skip
)

$filenameTag = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")

BeforeAll {
  . $PSScriptRoot/../internal/Import-AWSPowerShell.ps1
}

Describe "AWS Credential" -Tag AWSCredential, $filenameTag -Skip:($Skip) {
  It "Checking that a default profile does not exist" {
    $defaultProfiles = Get-AWSCredential -ListProfileDetail | Where-Object { $_.ProfileName -eq "default" }
    $defaultProfiles.Count | Should -be 0 -Because "a default profile should not exist"
  }
    # It "should not contain a profile for '<profilename>'" -ForEach $Profiles {
    #   $profiles = Get-AWSCredential -ListProfileDetail | Where-Object { $_.ProfileName -eq $ProfileName }
    #   $profiles.Count | Should -be 1 -Because "only one profile should match our requested name"
    #   $profiles[0].ProfileName | Should -Be $ProfileName
    # }
}
