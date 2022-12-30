<#
.SYNOPSIS
  Invokes sample Pester Tests
.DESCRIPTION
  Invokes sample Pester Tests based on the QuickStart Guide on Pester.dev
.EXAMPLE
  Invoke-SampleTests.ps1 -Skip

  Similar to `-WhatIf` it will run the Pester Tests, but will skip all tests.
  Useful when validating working Pester environment.
.EXAMPLE
  Invoke-SampleTests.ps1

  Run all of the sample unit tests.
.EXAMPLE
  Invoke-SampleTests.ps1 -Tag "Planet","Season"

  Run all of the sample unit tests that have the tag "Planet" or "Season".
.LINK
  https://pester.dev/docs/quick-start
#>

param (
    # Skip All Pester Tests
    # Can be useful when trying to validate test changes.
    [Parameter(Mandatory=$False)]
    [switch] $Skip,

    # Pester: Output (None, Normal, Detailed, Diagnostic)
    # ref: https://pester.dev/docs/usage/output
    [Parameter(Mandatory=$False)]
    [string] $Output = 'Detailed',

    # Pester: Stack Trace Output (None, FirstLine, Filtered, Full)
    # ref: https://pester.dev/docs/usage/output
    [Parameter(Mandatory=$False)]
    [string] $StackTraceVerbosity = 'None',

    # Pester: Tag(s) to filter tests to run (Allowed, Restricted)
    # ref: https://pester.dev/docs/usage/tags
    [Parameter(Mandatory=$False)]
    [string[]] $Tag = @(),

    # Pester: Tag(s) to exclude from tests to run (Allowed, Restricted)
    # ref: https://pester.dev/docs/usage/tags
    [Parameter(Mandatory=$False)]
    [string[]] $ExcludeTag = @(),

    # Pester: Return result object after finishing the test run.
    # ref: https://pester.dev/docs/commands/Invoke-Pester#-passthru
    [Parameter(Mandatory=$False)]
    [switch] $PassThru
)

. "$PSScriptRoot/../internal/Import-Pester.ps1"

# https://pester.dev/docs/commands/New-PesterConfiguration
$container = New-PesterContainer -Path "$PSScriptRoot/**/*.Tests.ps1" `
  -Data @{Skip = $Skip}

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