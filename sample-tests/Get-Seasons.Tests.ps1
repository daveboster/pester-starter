<#
.SYNOPSIS
    Pester Tests for `Get-Seasons`
#>

param (
    # Skip All Pester Tests
    # Can be useful when trying to validate test changes.
    [Parameter(Mandatory=$False)]
    [switch] $Skip
)

BeforeAll {
  # Note, if you check $PSScriptRoot from your terminal, it will be empty
  # It won't be when running Pester Tests
  . $PSScriptRoot/Get-Seasons.ps1
}

Describe 'Get-Seasons' -Skip:($Skip) {
  It 'Given no parameters, it lists all four seasons' {
      $allSeasons = Get-Seasons
      $allSeasons.Count | Should -Be 4
  }
}