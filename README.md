# AppyWay Octopus Deploy Worker Tools

These images include common tools used on AppyWay for Octopus steps and follow the patterns recommended by Octopus for creating custom workers.

The original images and documentation are in the [Octopus WorkerTools repository](https://github.com/OctopusDeploy/WorkerTools).

The worker images are available on [docker hub](https://hub.docker.com/r/appyway/worker-tools)

| Operating System  | Installed Tools and Versions |
| ------------- | ------------- |
| Ubuntu 20.04  | [Dockerfile](https://github.com/YellowLineParking/Appy.Octopus.WorkerTools/blob/master/ubuntu.20.04/Dockerfile)  |
| Windows Server Core 2019  | [Dockerfile](https://github.com/YellowLineParking/Appy.Octopus.WorkerTools/blob/master/windows.ltsc2019/Dockerfile)  |

## Getting Started

See the docs to get started using the custom `appyway/worker-tools` image as an [execution container for workers](https://octopus.com/docs/deployment-process/execution-containers-for-workers).

The images we publish are [semantically versioned](https://semver.org/). To ensure stability within your deployment processes, we recommend using the full `major.minor.patch` tag when using the `appyway/worker-tools` image - for example, use `2.0.2-ubuntu.20.04`, not `ubuntu.20.04`.

### Testing

To run these tests, you can see the instructions for [Ubuntu](#Ubuntu) and [Windows](#Windows)

N.B. all commands below should be run from the project root directory.

### Ubuntu

Our tests are implemented in `Pester`, which relies on `PowerShell`.

#### Option 1: Build and Test scripts

```bash
./build.sh --image-directory='ubuntu.20.04'
```

Runs a build and test of the `ubuntu.20.04` container

#### Option 2: DIY

```bash
cd ubuntu.20.04
docker build . -t worker-tools
docker build . -t worker-tools-tests -f Tests.Dockerfile --build-arg ContainerUnderTest=worker-tools
docker run -it -v `pwd`:/app worker-tools-tests pwsh
```

Then within the running docker container

```powershell
/app/scripts/run-tests.ps1
```

### Windows

#### Option 1: Build and Test scripts

```powershell
build.ps1 -image-directory 'windows.ltsc2019'
```

Runs a build and test of the `windows.ltsc2019` container

#### Option 2: DIY

```powershell
cd windows.ltsc2019
docker build . -t worker-tools
docker build . -t worker-tools-tests -f Tests.Dockerfile --build-arg ContainerUnderTest=worker-tools
docker run -it -v ${pwd}:c:\app worker-tools-tests pwsh
```

Then within the running docker container

```powershell
/app/scripts/run-tests.ps1
```