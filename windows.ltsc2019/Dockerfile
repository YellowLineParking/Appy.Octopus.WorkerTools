# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-Command"]

ARG Azure_Cli_Version=2.37.0
ARG Azure_Powershell_Version=8.0.0
ARG Newtonsoft_Powershell_Version=1.0.2.201
ARG Yaml_Powershell_Version=0.4.2
ARG Node_Version=14.17.2
ARG Octopus_Cli_Version=8.0.1
ARG Octopus_Client_Version=13.0.3807
ARG Powershell_Version=7.2.4
ARG 7Zip_Version=19.0
ARG GIT_VERSION=2.36.0
ARG Pulumi_Cli_Version=3.33.2

# Install Choco
RUN $ProgressPreference = 'SilentlyContinue'; `
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install dotnet 6.0+
RUN Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -outFile 'dotnet-install.ps1'; `
    [Environment]::SetEnvironmentVariable('DOTNET_CLI_TELEMETRY_OPTOUT', '1', 'Machine'); `
    .\dotnet-install.ps1 -Channel '6.0'; `
    rm dotnet-install.ps1

# Install Azure CLI
RUN choco install azure-cli -y --version $Env:Azure_Cli_Version --no-progress

# # Install Nuget PowerShell modules
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force;

# # Install Newtonsoft.json
RUN Install-Module -Name newtonsoft.json -Scope AllUsers  -Force -MaximumVersion $Env:Newtonsoft_Powershell_Version

# # Install Powershell-Yaml
RUN Install-Module -Name Powershell-Yaml -Scope AllUsers  -Force -MaximumVersion $Env:Yaml_Powershell_Version

# # Install Azure PowerShell modules
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.6.1
RUN Install-Module -Force -Name Az -AllowClobber -Scope AllUsers -MaximumVersion $Env:Azure_Powershell_Version; `
    Enable-AzureRmAlias -Scope LocalMachine

# # Install NodeJS
RUN choco install nodejs-lts -y --version $Env:Node_Version --no-progress

# # Install 7ZIP because gcloud
RUN choco install 7zip -y --version $Env:7Zip_Version --no-progress

# # Install octo
RUN choco install octopustools -y --version $Env:Octopus_Cli_Version --no-progress

# # Install Octopus Client
RUN Install-Package Octopus.Client -source https://www.nuget.org/api/v2 -SkipDependencies -Force -RequiredVersion $Env:Octopus_Client_Version

# # Install Powershell Core
RUN choco install powershell-core --yes --version $Env:Powershell_Version --no-progress

# # Install Git
RUN choco install -y git --version $ENV:GIT_VERSION

# # Install Pulumi
RUN choco install pulumi -y --version $ENV:Pulumi_Cli_Version --no-progress

# # Update path for new tools
ADD .\scripts\update_path.cmd C:\update_path.cmd
RUN .\update_path.cmd;