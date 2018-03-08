Param(
  [string]$solutionPublisherDirectory = "C:\Program Files\SolutionPublisher",
  [string]$configurationRelativePath = "BuildConfigurations\SolutionPublisherConfiguration.xml"
)

# Variables
$rootPath = $env:BUILD_SOURCESDIRECTORY
$buildNumber = $env:BUILD_BUILDNUMBER
$pattern = "\d+\.\d+\.\d+\.\d+"
$patternSplitCharacters = "."

# Check $buildNumber
	
if ($buildNumber -match $pattern -ne $true) {
    throw "Could not extract a version from [$buildNumber] using pattern [$pattern]"
}

# Set $buildVersion

$extractedBuildNumbers = @($Matches[0].Split(([char[]]$patternSplitCharacters)))
if ($extractedBuildNumbers.Length -ne 4) {
    throw "The extracted build number $($Matches[0]) does not contain the expected 4 elements"
}
$buildVersion = [string]::Join(([char[]]$patternSplitCharacters),($extractedBuildNumbers | select -First 4))

# Declare functions

function Replace-Tag($configurationContent, $tagName, $replacement) {

	$encodedTagName = [System.Web.HttpUtility]::UrlEncode($tagName)
	$encodedReplacement = [System.Web.HttpUtility]::UrlEncode($replacement)
    $configurationContent = $configurationContent.Replace($encodedTagName, $encodedReplacement)
	return $configurationContent
}

# Add types

Add-Type -AssemblyName System.Web

# Update configuration replacing tags

$configurationContent = [System.IO.File]::ReadAllText([System.IO.Path]::Combine($rootPath, $configurationRelativePath))

$configurationContent = $configurationContent.Replace('$BuildVersion$', $buildVersion)

$configurationContent = $configurationContent.Replace('$AgentBuildDirectory$',  $env:AGENT_BUILDDIRECTORY)
$configurationContent = $configurationContent.Replace('$AgentHomeDirectory$',  $env:AGENT_HOMEDIRECTORY)
$configurationContent = $configurationContent.Replace('$AgentId$',  $env:AGENT_ID)
$configurationContent = $configurationContent.Replace('$AgentJobStatus$',  $env:AGENT_JOBSTATUS)
$configurationContent = $configurationContent.Replace('$AgentMachineName$',  $env:AGENT_MACHINENAME)
$configurationContent = $configurationContent.Replace('$AgentName$',  $env:AGENT_NAME)
$configurationContent = $configurationContent.Replace('$AgentWorkFolder$',  $env:AGENT_WORKFOLDER)
$configurationContent = $configurationContent.Replace('$BuildArtifactStagingDirectory$',  $env:BUILD_ARTIFACTSTAGINGDIRECTORY)
$configurationContent = $configurationContent.Replace('$BuildBuildId$',  $env:BUILD_BUILDID)
$configurationContent = $configurationContent.Replace('$BuildBuildNumber$',  $env:BUILD_BUILDNUMBER)
$configurationContent = $configurationContent.Replace('$BuildBuildUri$',  $env:BUILD_BUILDURI)
$configurationContent = $configurationContent.Replace('$BuildBinariesDirectory$',  $env:BUILD_BINARIESDIRECTORY)
$configurationContent = $configurationContent.Replace('$BuildDefinitionName$',  $env:BUILD_DEFINITIONNAME)
$configurationContent = $configurationContent.Replace('$BuildDefinitionVersion$',  $env:BUILD_DEFINITIONVERSION)
$configurationContent = $configurationContent.Replace('$BuildQueuedBy$',  $env:BUILD_QUEUEDBY)
$configurationContent = $configurationContent.Replace('$BuildQueuedById$',  $env:BUILD_QUEUEDBYID)
$configurationContent = $configurationContent.Replace('$BuildReason$',  $env:BUILD_REASON)
$configurationContent = $configurationContent.Replace('$BuildRepositoryClean$',  $env:BUILD_REPOSITORY_CLEAN)
$configurationContent = $configurationContent.Replace('$BuildRepositoryLocalPath$',  $env:BUILD_REPOSITORY_LOCALPATH)
$configurationContent = $configurationContent.Replace('$BuildRepositoryName$',  $env:BUILD_REPOSITORY_NAME)
$configurationContent = $configurationContent.Replace('$BuildRepositoryProvider$',  $env:BUILD_REPOSITORY_PROVIDER)
$configurationContent = $configurationContent.Replace('$BuildRepositoryTfvcWorkspace$',  $env:BUILD_REPOSITORY_TFVC_WORKSPACE)
$configurationContent = $configurationContent.Replace('$BuildRepositoryUri$',  $env:BUILD_REPOSITORY_URI)
$configurationContent = $configurationContent.Replace('$BuildRequestedFor$',  $env:BUILD_REQUESTEDFOR)
$configurationContent = $configurationContent.Replace('$BuildRequestedForEmail$',  $env:BUILD_REQUESTEDFOREMAIL)
$configurationContent = $configurationContent.Replace('$BuildRequestedForId$',  $env:BUILD_REQUESTEDFORID)
$configurationContent = $configurationContent.Replace('$BuildSourceBranch$',  $env:BUILD_SOURCEBRANCH)
$configurationContent = $configurationContent.Replace('$BuildSourceBranchName$',  $env:BUILD_SOURCEBRANCHNAME)
$configurationContent = $configurationContent.Replace('$BuildSourcesDirectory$',  $env:BUILD_SOURCESDIRECTORY)
$configurationContent = $configurationContent.Replace('$BuildSourceVersion$',  $env:BUILD_SOURCEVERSION)
$configurationContent = $configurationContent.Replace('$BuildStagingDirectory$',  $env:BUILD_STAGINGDIRECTORY)
$configurationContent = $configurationContent.Replace('$BuildRepositoryGitSubmoduleCheckout$',  $env:BUILD_REPOSITORY_GIT_SUBMODULECHECKOUT)
$configurationContent = $configurationContent.Replace('$BuildSourceTfvcShelveset$',  $env:BUILD_SOURCETFVCSHELVESET)
$configurationContent = $configurationContent.Replace('$CommonTestResultsDirectory$',  $env:COMMON_TESTRESULTSDIRECTORY)
$configurationContent = $configurationContent.Replace('$SystemAccessToken$',  $env:SYSTEM_ACCESSTOKEN)
$configurationContent = $configurationContent.Replace('$SystemCollectionId$',  $env:SYSTEM_COLLECTIONID)
$configurationContent = $configurationContent.Replace('$SystemDefaultWorkingDirectory$',  $env:SYSTEM_DEFAULTWORKINGDIRECTORY)
$configurationContent = $configurationContent.Replace('$SystemDefinitionId$',  $env:SYSTEM_DEFINITIONID)
$configurationContent = $configurationContent.Replace('$SystemPullRequestIsFork$',  $env:SYSTEM_PULLREQUEST_ISFORK)
$configurationContent = $configurationContent.Replace('$SystemPullRequestPullRequestId$',  $env:SYSTEM_PULLREQUEST_PULLREQUESTID)
$configurationContent = $configurationContent.Replace('$SystemPullRequestSourceBranch$',  $env:SYSTEM_PULLREQUEST_SOURCEBRANCH)
$configurationContent = $configurationContent.Replace('$SystemPullRequestSourceRepositoryURI$',  $env:SYSTEM_PULLREQUEST_SOURCEREPOSITORYURI)
$configurationContent = $configurationContent.Replace('$SystemPullRequestTargetBranch$',  $env:SYSTEM_PULLREQUEST_TARGETBRANCH)
$configurationContent = $configurationContent.Replace('$SystemTeamFoundationCollectionUri$',  $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)
$configurationContent = $configurationContent.Replace('$SystemTeamProject$',  $env:SYSTEM_TEAMPROJECT)
$configurationContent = $configurationContent.Replace('$SystemTeamProjectId$',  $env:SYSTEM_TEAMPROJECTID)
$configurationContent = $configurationContent.Replace('$TfBuild$',  $env:TF_BUILD)


$encodedUrlConfiguration = [System.Web.HttpUtility]::UrlEncode($configurationContent)

# Run SolutionPublisher
$solutionPublisherPath = [System.IO.Path]::Combine($solutionPublisherDirectory,'SolutionPublisher.exe')

if (-Not [System.IO.File]::Exists($solutionPublisherPath)) {
    throw "Could not find file [$solutionPublisherPath]"
}

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = $solutionPublisherPath
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = $encodedUrlConfiguration
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()
Write-Host $solutionPublisherPath
Write-Host "StandardOutput:"
Write-Host $stdout
Write-Host "StandardError:"
Write-Host $stderr
Write-Host "ExitCode:" $p.ExitCode

if ($p.ExitCode -ne 0){
    throw "Error running [$solutionPublisherPath]. Exit code: [$p.ExitCode]"
}