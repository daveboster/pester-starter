function Get-Seasons ([string]$Name = '*') {
  $seasons = @(
      @{ Name = 'Winter' }
      @{ Name = 'Spring'   }
      @{ Name = 'Summer'   }
      @{ Name = 'Fall'    }
  ) | ForEach-Object { [PSCustomObject] $_ }

  $seasons | Where-Object { $_.Name -like $Name }
}