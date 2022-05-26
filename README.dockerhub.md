# About This Image

These images include common tools used on AppyWay for Octopus steps and follow the patterns recommended by Octopus for creating custom workers.

The original images and documentation are in the [Octopus WorkerTools repository](https://github.com/OctopusDeploy/WorkerTools).

# How to Use the Image

Pick an image that is suitable for your needs based on OS + distribution.

| Operating System  | Installed Tools and Versions |
| ------------- | ------------- |
| Ubuntu 20.04  | [Installed tools](./ubuntu.20.04/README.md) ([Dockerfile](https://github.com/YellowLineParking/Appy.Octopus.WorkerTools/blob/master/ubuntu.20.04/Dockerfile))  |
| Windows Server Core 2019  | [Installed tools](./windows.ltsc2019/README.md) ([Dockerfile](https://github.com/YellowLineParking/Appy.Octopus.WorkerTools/blob/master/windows.ltsc2019/Dockerfile))  |

The images we publish have multiple release tracks, and are [semantically versioned](https://semver.org/). To ensure stability within your deployment processes, we recommend using the full `major.minor.patch` tag when using the `appyway/worker-tools` image - for example, use `2.0.2-ubuntu.20.04`, not `ubuntu.20.04`, unless you have a particular use-case that is more tolerant of changes.

Release Track  | Ubuntu | Windows 
---------| --------------- | ---
latest | ubuntu.20.04 | windows.ltsc2019
Major | 1-ubuntu.20.04 | 1-windows.ltsc2019
Major.Minor | 1.0-ubuntu.20.04 | 1.0-windows.ltsc2019
Major.Minor.Patch | 1.0.1-ubuntu.20.04 | 1.0.2-windows.ltsc2019

# Full Tag Listing

## Windows Server 2019 amd64 Tags
Tag | Dockerfile
---------| ---------------
windows.ltsc2019 | [Dockerfile](https://github.com/YellowLineParking/Appy.Octopus.WorkerTools/blob/master/windows.ltsc2019/Dockerfile)

## Ubuntu Tags
Tag | Dockerfile
---------| ---------------
ubuntu.20.04 | [Dockerfile](https://github.com/YellowLineParking/Appy.Octopus.WorkerTools/blob/master/ubuntu.20.04/Dockerfile)

You can retrieve a list of all available tags for appyway/worker-tools at https://hub.docker.com/v2/repositories/appyway/worker-tools/tags.