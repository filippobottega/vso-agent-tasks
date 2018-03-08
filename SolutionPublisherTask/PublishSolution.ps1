Param(
  [string]$rootPath = $env:BUILD_SOURCESDIRECTORY,
  [string]$buildNumber = $env:BUILD_BUILDNUMBER,
  [regex]$pattern = "\d+\.\d+\.\d+\.\d+",
  [string]$patternSplitCharacters = ".",
  [string]$solutionPublisherDirectory = "C:\Program Files\SolutionPublisher",
  [string]$encodedUrlConfiguration = ""
)
	
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

function Replace-Tag($encodedContent, $tagName, $replacement) {

	$encodedTagName = [System.Web.HttpUtility]::UrlEncode($tagName)
	$encodedReplacement = [System.Web.HttpUtility]::UrlEncode($replacement)
    $encodedContent = $encodedContent.Replace($encodedTagName, $encodedReplacement)
	return $encodedContent
}

# Add types

Add-Type -AssemblyName System.Web

# Replace tags

$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildVersion$' -replacement $buildVersion

$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentBuildDirectory$' -replacement $env:AGENT_BUILDDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentHomeDirectory$' -replacement $env:AGENT_HOMEDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentId$' -replacement $env:AGENT_ID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentJobStatus$' -replacement $env:AGENT_JOBSTATUS
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentMachineName$' -replacement $env:AGENT_MACHINENAME
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentName$' -replacement $env:AGENT_NAME
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$AgentWorkFolder$' -replacement $env:AGENT_WORKFOLDER
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildArtifactStagingDirectory$' -replacement $env:BUILD_ARTIFACTSTAGINGDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildBuildId$' -replacement $env:BUILD_BUILDID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildBuildNumber$' -replacement $env:BUILD_BUILDNUMBER
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildBuildUri$' -replacement $env:BUILD_BUILDURI
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildBinariesDirectory$' -replacement $env:BUILD_BINARIESDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildDefinitionName$' -replacement $env:BUILD_DEFINITIONNAME
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildDefinitionVersion$' -replacement $env:BUILD_DEFINITIONVERSION
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildQueuedBy$' -replacement $env:BUILD_QUEUEDBY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildQueuedById$' -replacement $env:BUILD_QUEUEDBYID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildReason$' -replacement $env:BUILD_REASON
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryClean$' -replacement $env:BUILD_REPOSITORY_CLEAN
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryLocalPath$' -replacement $env:BUILD_REPOSITORY_LOCALPATH
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryName$' -replacement $env:BUILD_REPOSITORY_NAME
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryProvider$' -replacement $env:BUILD_REPOSITORY_PROVIDER
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryTfvcWorkspace$' -replacement $env:BUILD_REPOSITORY_TFVC_WORKSPACE
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryUri$' -replacement $env:BUILD_REPOSITORY_URI
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRequestedFor$' -replacement $env:BUILD_REQUESTEDFOR
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRequestedForEmail$' -replacement $env:BUILD_REQUESTEDFOREMAIL
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRequestedForId$' -replacement $env:BUILD_REQUESTEDFORID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildSourceBranch$' -replacement $env:BUILD_SOURCEBRANCH
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildSourceBranchName$' -replacement $env:BUILD_SOURCEBRANCHNAME
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildSourcesDirectory$' -replacement $env:BUILD_SOURCESDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildSourceVersion$' -replacement $env:BUILD_SOURCEVERSION
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildStagingDirectory$' -replacement $env:BUILD_STAGINGDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildRepositoryGitSubmoduleCheckout$' -replacement $env:BUILD_REPOSITORY_GIT_SUBMODULECHECKOUT
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$BuildSourceTfvcShelveset$' -replacement $env:BUILD_SOURCETFVCSHELVESET
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$CommonTestResultsDirectory$' -replacement $env:COMMON_TESTRESULTSDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemAccessToken$' -replacement $env:SYSTEM_ACCESSTOKEN
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemCollectionId$' -replacement $env:SYSTEM_COLLECTIONID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemDefaultWorkingDirectory$' -replacement $env:SYSTEM_DEFAULTWORKINGDIRECTORY
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemDefinitionId$' -replacement $env:SYSTEM_DEFINITIONID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemPullRequestIsFork$' -replacement $env:SYSTEM_PULLREQUEST_ISFORK
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemPullRequestPullRequestId$' -replacement $env:SYSTEM_PULLREQUEST_PULLREQUESTID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemPullRequestSourceBranch$' -replacement $env:SYSTEM_PULLREQUEST_SOURCEBRANCH
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemPullRequestSourceRepositoryURI$' -replacement $env:SYSTEM_PULLREQUEST_SOURCEREPOSITORYURI
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemPullRequestTargetBranch$' -replacement $env:SYSTEM_PULLREQUEST_TARGETBRANCH
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemTeamFoundationCollectionUri$' -replacement $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemTeamProject$' -replacement $env:SYSTEM_TEAMPROJECT
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$SystemTeamProjectId$' -replacement $env:SYSTEM_TEAMPROJECTID
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$TfBuild$' -replacement $env:TF_BUILD

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