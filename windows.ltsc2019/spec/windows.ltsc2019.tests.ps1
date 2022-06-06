$ErrorActionPreference = "Continue"

$pesterModules = @( Get-Module -Name "Pester");
Write-Host 'Running tests with Pester v'+$($pesterModules[0].Version)

Describe  'installed dependencies' {
    It 'has powershell installed' {
        $output = & powershell -command "`$PSVersionTable.PSVersion.ToString()"
        $LASTEXITCODE | Should -be 0
        $output | Should -Match '^5\.1\.'
    }

    It 'has Octopus.Client installed ' {
        $expectedVersion = "13.0.3807"
        Test-Path "C:\Program Files\PackageManagement\NuGet\Packages\Octopus.Client.$expectedVersion\lib\net452\Octopus.Client.dll" | Should -Be $true
        [Reflection.AssemblyName]::GetAssemblyName("C:\Program Files\PackageManagement\NuGet\Packages\Octopus.Client.$expectedVersion\lib\net452\Octopus.Client.dll").Version.ToString() | Should -Match "$expectedVersion.0"
    }

    It 'has dotnet installed' {
        dotnet --version | Should -Match '6.0.\d+'
        $LASTEXITCODE | Should -be 0
    }

    It 'has az installed' {
      $output = (& az version) | convertfrom-json
      $output.'azure-cli' | Should -Be '2.37.0'
      $LASTEXITCODE | Should -be 0
    }

    It 'has newtonsoft.json powershell module installed' {
        (Get-Module newtonsoft.json -ListAvailable).Version.ToString() | should -be '1.0.2.201'
    }

    It 'has Powershell-Yaml powershell module installed' {
        (Get-Module Powershell-Yaml -ListAvailable).Version.ToString() | should -be '0.4.2'
    }

    It 'has az powershell module installed' {
        (Get-Module Az -ListAvailable).Version.ToString() | should -be '8.0.0'
    }

    It 'has node installed' {
        node --version | Should -Match '14.17.2'
        $LASTEXITCODE | Should -be 0
    }

    It 'has octo installed' {
        octo --version | Should -Match '8.0.1'
        $LASTEXITCODE | Should -be 0
    }

    It 'has 7zip installed' {
        $output = (& "C:\Program Files\7-Zip\7z.exe" --help) -join "`n"
        $output | Should -Match '7-Zip 19.00'
        $LASTEXITCODE | Should -be 0
    }

    It 'should have installed powershell core' {
        $output = & pwsh --version
        $LASTEXITCODE | Should -be 0
        $output | Should -Match '^PowerShell 7\.2\.4*'
    }

    It 'should have installed git' {
        $output = & git --version
        $LASTEXITCODE | Should -be 0
        $output | Should -Match '^git version 2\.36\.0\.windows.*'
    }

    It 'should have installed pulumi cli' {
        $output = & pulumi version
        $LASTEXITCODE | Should -be 0
        $output | Should -Match '^v3\.33\.2*'
    }
}