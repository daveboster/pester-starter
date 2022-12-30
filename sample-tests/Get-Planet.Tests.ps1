<#
.SYNOPSIS
    Pester Tests for `Get-Planet`
.DESCRIPTION
    Pester Tests for `Get-Planet` and an example of starting test-driven development (TDD)
    and declaring the function under test within the same file.
#>

param (
  # Skip All Pester Tests
  # Can be useful when trying to validate test changes.
  [Parameter(Mandatory=$False)]
  [switch] $Skip
)

BeforeAll {
  function Get-Planet ([string]$Name = '*') {
      $planets = @(
          @{ Name = 'Mercury' }
          @{ Name = 'Venus'   }
          @{ Name = 'Earth'   }
          @{ Name = 'Mars'    }
          @{ Name = 'Jupiter' }
          @{ Name = 'Saturn'  }
          @{ Name = 'Uranus'  }
          @{ Name = 'Neptune' }
      ) | ForEach-Object { [PSCustomObject] $_ }

      $planets | Where-Object { $_.Name -like $Name }
  }
}

Describe 'Get-Planet' -Skip:($Skip) {
  It 'Given no parameters, it lists all 8 planets' {
      $allPlanets = Get-Planet
      $allPlanets.Count | Should -Be 8
  }
}