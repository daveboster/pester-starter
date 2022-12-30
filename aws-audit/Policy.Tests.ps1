<#
.SYNOPSIS
  Tests for AWS S3 Buckets
#>

param (
  # AWS Credential Profile Name to pass to AWS-PowerShell
  [Parameter(Mandatory=$false)]
  [string] $ProfileName,

  # AWS Region to pass to AWS-PowerShell
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


  $awsParameters = @{ }

  if($null -ne $ProfileName -and $ProfileName -ne "")  {
      $awsParameters.Add("ProfileName", $ProfileName)
  }

  if($null -ne $Region -and $Region -ne "") {
      $awsParameters.Add("Region", $Region)
  }
}

Describe "Verify Access" -Tag VerifyAccess, $filenameTag -Skip:($Skip) {
  Context "S3 Operations" {
      It "should return a list of S3 buckets" {
          {
              $buckets = @{ Count = -1 }
              $buckets = Get-S3Bucket @awsParameters
              $buckets.Count | Should -BeGreaterOrEqual 0
          } | Should -Not -Throw
      }
  }
}
