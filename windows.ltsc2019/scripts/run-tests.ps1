Write-Output "Starting Pester tests"

try {
    Install-Module -Name "Pester" -MinimumVersion "5.0.2" -Force

    Import-Module -Name "Pester"

    Set-Location /app/windows.ltsc2019/spec

    Write-Output "Running Pester Tests"
    $configuration = [PesterConfiguration]::Default
    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.OutputPath = '/app/windows.ltsc2019/spec/PesterTestResults.xml'
    $configuration.TestResult.OutputFormat = 'NUnitXml'
    $configuration.Run.PassThru = $true

    Invoke-Pester -configuration $configuration
} catch {
    exit 1
}
Write-Output "Ended Pester tests"