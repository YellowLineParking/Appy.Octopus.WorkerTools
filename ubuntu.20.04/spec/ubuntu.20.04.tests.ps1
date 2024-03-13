$ErrorActionPreference = "Continue"

Install-Module Pester -Force
Import-Module Pester

$pesterModules = @( Get-Module -Name "Pester");
Write-Host 'Running tests with Pester v'+$($pesterModules[0].Version)

Describe  'installed dependencies' {
    It 'has Octopus.Client installed ' {
        $expectedVersion = "13.0.3807"
        [Reflection.AssemblyName]::GetAssemblyName("/Octopus.Client.dll").Version.ToString() | Should -match "$expectedVersion.0"
    }

    It 'has dotnet installed' {
        dotnet --version | Should -match '6.0.\d+'
        $LASTEXITCODE | Should -be 0
    }

    It 'has java installed' {
        java --version | Should -beLike "*11.0.22*"
        $LASTEXITCODE | Should -be 0
    }

    It 'has az installed' {
      $output = (& az version) | convertfrom-json
      $output.'azure-cli' | Should -be '2.37.0'
      $LASTEXITCODE | Should -be 0
    }

    It 'has az powershell module installed' {
        (Get-Module Az -ListAvailable).Version.ToString() | should -be '8.0.0'
    }

    It 'has octo installed' {
        octo --version | Should -match '9.0.0'
        $LASTEXITCODE | Should -be 0
    }

    It 'should have installed powershell core' {
        $output = & pwsh --version
        $LASTEXITCODE | Should -be 0
        $output | Should -match '^PowerShell 7\.2\.4*'
    }

    It 'has node installed' {
        node --version | Should -match '20.\d+.\d+'
        $LASTEXITCODE | Should -be 0
    }

    It 'has firebase-tools installed' {
        firebase --version | Should -match '11.\d+.\d+'
        $LASTEXITCODE | Should -be 0
    }
}