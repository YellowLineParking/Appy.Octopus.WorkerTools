FROM ubuntu:20.04

ARG Java_Jdk_Version=11.0.22+7-0ubuntu2~20.04.1
ARG Azure_Cli_Version=2.37.0\*
ARG Azure_Powershell_Version=8.0.0
ARG Octopus_Cli_Version=9.0.0
ARG Octopus_Client_Version=13.0.3807
ARG Powershell_Version=7.2.4\*
ARG FirebaseTools_Version=11.20.0

# get `wget` & software-properties-common
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7#ubuntu-2004
RUN apt-get update && \
    apt-get install -y wget unzip apt-utils curl software-properties-common

# Get JDK
# https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04
# https://packages.ubuntu.com/bionic/openjdk-11-dbg
RUN apt-get install -y openjdk-11-jdk-headless=${Java_Jdk_Version}

# Get Powershell for 20.04
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    add-apt-repository universe && \
    apt-get install -y powershell=${Powershell_Version}

# Get Octo CLI
# https://octopus.com/downloads/octopuscli#linux
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
    curl -sSfL https://apt.octopus.com/public.key | apt-key add - && \
    sh -c "echo deb https://apt.octopus.com/ stable main > /etc/apt/sources.list.d/octopus.com.list" && \
    apt-get update && \
    apt-get install -y octopuscli=${Octopus_Cli_Version}

# Install Octopus Client
# https://octopus.com/docs/octopus-rest-api/octopus.client
RUN pwsh -c 'Install-Package -Force Octopus.Client -MaximumVersion "'${Octopus_Client_Version}'" -source https://www.nuget.org/api/v2 -SkipDependencies' && \
    octopusClientPackagePath=$(pwsh -c '(Get-Item ((Get-Package Octopus.Client).source)).Directory.FullName') && \
    cp -r $octopusClientPackagePath/lib/netstandard2.0/* .

# Get AZ Powershell core modules
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-8.0.0
RUN pwsh -c 'Install-Module -Force -Name Az -AllowClobber -Scope AllUsers -MaximumVersion "'${Azure_Powershell_Version}'"'

# Get .NET SDK 6.0
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004
RUN DOTNET_CLI_TELEMETRY_OPTOUT=1 && \
    echo "export DOTNET_CLI_TELEMETRY_OPTOUT=1" > /etc/profile.d/set-dotnet-env-vars.sh && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0

# Get Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN wget --quiet -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli=${Azure_Cli_Version}

# Get NodeJS
# https://websiteforstudents.com/how-to-install-node-js-10-11-12-on-ubuntu-16-04-18-04-via-apt-and-snap/\
RUN wget --quiet -O - https://deb.nodesource.com/setup_20.x | bash && \
    apt-get install -y nodejs

# Install firebase-tools
RUN npm install -g firebase-tools@${FirebaseTools_Version}