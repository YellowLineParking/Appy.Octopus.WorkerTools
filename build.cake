#addin nuget:?package=Cake.MinVer&version=2.0.0
#addin nuget:?package=Cake.Docker&version=1.1.2

public class AppyDockerTag
{
    MinVerVersion _versionInfo;

    public AppyDockerTag(MinVerVersion versionInfo, string dockerNamespace, string imageDirectory)
    {
        DockerNamespace = dockerNamespace;
        _versionInfo = versionInfo;
        ImageDirectory = imageDirectory;
        Version =  $"{_versionInfo.Major}.{_versionInfo.Minor}.{_versionInfo.Patch}";
        ImageName = CreateTag(Version);
    }

    public string ImageDirectory { get; set; }
    public string DockerNamespace { get; }
    public string ImageName { get; }
    public string Version { get; set; }
    public string Tag { get; set; }

    public string[] Tags() => new []
    {
        CreateTag("latest"),
        CreateTag(Version),
        CreateTag(_versionInfo.Major.ToString()),
        CreateTag($"{_versionInfo.Major}.{_versionInfo.Minor}")
    };

    string CreateTag(string version) => version == "latest"
        ? $"{DockerNamespace}:{ImageDirectory}"
        : $"{DockerNamespace}:{string.Join(".", version)}-{ImageDirectory}";
}

var basePath = ".";
var organization = "appyway";
var target = Argument("target", "Default");
var dockerNamespace = Argument("docker-namespace", "appyway/worker-tools");
var imageDirectory = Argument("image-directory", "ubuntu.20.04");
AppyDockerTag dockerTag;
string testContainerName = "test-container";
var versionInfo = MinVer(settings => settings
    .WithDefaultPreReleasePhase("preview")
    .WithVerbosity(MinVerVerbosity.Info));

////////////////////////////////////////////////////////////////
// Setup

Setup((context) =>
{
    Information("AppyWay");
    Information($"Version: {versionInfo.Version}");
    Information("Building {0} images v{1}", dockerNamespace, versionInfo.Version);
    dockerTag = new AppyDockerTag(versionInfo, dockerNamespace, imageDirectory);
});

////////////////////////////////////////////////////////////////
// Tasks

Task("Build")
    .Does(context =>
{
    Information("Tags to be built:");
    var tags = dockerTag.Tags();
    tags.ToList().ForEach((tag) => Information(tag));

    DockerBuild(new DockerImageBuildSettings
    {
        Tag = tags
    }, dockerTag.ImageDirectory);

    Information("Building test container {0} with ContainerUnderTest={1}", testContainerName, dockerTag.ImageName);

    var buildSettings = new DockerImageBuildSettings {
        Tag = new [] { testContainerName },
        BuildArg = new [] {  $"ContainerUnderTest={dockerTag.ImageName}" }
    };

    if (IsRunningOnUnix())
    {
        buildSettings.File = $"{dockerTag.ImageDirectory}/Tests.Dockerfile";
    }
    else
    {
        buildSettings.File = $"{dockerTag.ImageDirectory}\\Tests.Dockerfile";
    }

    DockerBuild(buildSettings, dockerTag.ImageDirectory);
});

Task("Test")
    .IsDependentOn("Build")
    .Does(context =>
{
    var currentDirectory = MakeAbsolute(Directory("./"));

    try
    {
        Information("Running tests in {0} for {1}", testContainerName, dockerTag.ImageName);

        ProcessSettings processSettings;

        if (IsRunningOnUnix())
        {
            processSettings = new ProcessSettings
            {
                Arguments = $"run -v {currentDirectory}:/app {testContainerName} pwsh -file /app/{dockerTag.ImageDirectory}/scripts/run-tests.ps1"
            };
        }
        else
        {
            processSettings = new ProcessSettings
            {
                Arguments = $"run -v {currentDirectory}:c:\\app {testContainerName} pwsh -file /app/{dockerTag.ImageDirectory}/scripts/run-tests.ps1"
            };
        }

        using (var process = StartAndReturnProcess("docker", processSettings))
        {
            process.WaitForExit();
            Information("Exit code: {0}", process.GetExitCode());
            if (process.GetExitCode() > 0)
            {
                throw new Exception("Tests exited with exit code greater than 0");
            }
        }
    }
    catch (Exception ex)
    {
        Information(ex);
        throw;
    }
});

Task("Publish-Docker-DockerHub")
    .IsDependentOn("Test")
    .WithCriteria(ctx => BuildSystem.IsRunningOnGitHubActions, "Not running on GitHub Actions")
    .Does(context =>
{
    try
    {
        var tags = dockerTag.Tags();
        foreach(var tag in tags)
        {
            using(var process = StartAndReturnProcess("docker", new ProcessSettings{ Arguments = $"push {tag}" }))
            {
                process.WaitForExit();
                Information("Exit code: {0}", process.GetExitCode());
                if (process.GetExitCode() > 0)
                {
                    throw new Exception("Pushing docker image failed");
                }
            }
        }
    }
    catch (Exception ex)
    {
        Information(ex);
        throw;
    }
});

////////////////////////////////////////////////////////////////
// Targets

Task("Publish")
    .IsDependentOn("Publish-Docker-DockerHub");

Task("Default")
    .IsDependentOn("Test");

////////////////////////////////////////////////////////////////
// Execution

RunTarget(target)