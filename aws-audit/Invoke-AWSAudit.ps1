<#
.SYNOPSIS
  Invokes AWS Audit Tests PoC
.DESCRIPTION
  Proof of Concept for doing Amazon Cloud Audits using Pester.
.EXAMPLE
  Invoke-AWSAudit.ps1 -Skip

  Similar to `-WhatIf` it will run the Pester Tests, but will skip all tests.
  Useful when validating working Pester environment.
.EXAMPLE
  Invoke-AWSAudit.ps1

  Run all AWS Audit tests.
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
  [switch] $Skip,

  # Pester: Output (None, Normal, Detailed, Diagnostic)
  # ref: https://pester.dev/docs/usage/output
  [Parameter(Mandatory=$false)]
  [string] $Output = 'Detailed',

  # Pester: Stack Trace Output (None, FirstLine, Filtered, Full)
  # ref: https://pester.dev/docs/usage/output
  [Parameter(Mandatory=$false)]
  [string] $StackTraceVerbosity = 'None',

  # Pester: Tag(s) to filter tests to run (Allowed, Restricted)
  # ref: https://pester.dev/docs/usage/tags
  [Parameter(Mandatory=$false)]
  [string[]] $Tag = @(),

  # Pester: Tag(s) to exclude from tests to run (Allowed, Restricted)
  # ref: https://pester.dev/docs/usage/tags
  [Parameter(Mandatory=$false)]
  [string[]] $ExcludeTag = @(),

  # Pester: Return result object after finishing the test run.
  # ref: https://pester.dev/docs/commands/Invoke-Pester#-passthru
  [Parameter(Mandatory=$false)]
  [switch] $PassThru
)

. "$PSScriptRoot/../internal/Import-Pester.ps1"

# https://pester.dev/docs/commands/New-PesterConfiguration
$container = New-PesterContainer -Path "$PSScriptRoot/**/*.Tests.ps1" `
  -Data @{ProfileName = $ProfileName; Region = $Region; Skip = $Skip}

$pesterConfiguration = New-PesterConfiguration -Hashtable @{
    Run = @{ # Run configuration.
        Container = $container
        PassThru = $PassThru # Return result object after finishing the test run.
    }
    Filter = @{
        Tag = $Tag
        ExcludeTag = $ExcludeTag
    }
    Output = @{
        Verbosity = $Output
        StackTraceVerbosity = $StackTraceVerbosity
    }
}

Invoke-Pester -Configuration $pesterConfiguration