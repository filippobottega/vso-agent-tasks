Param(
  [string]$rootPath = $env:BUILD_SOURCESDIRECTORY,
  [string]$buildNumber = $env:BUILD_BUILDNUMBER,
  [regex]$pattern = "\d+\.\d+\.\d+\.\d+",
  [string]$patternSplitCharacters = ".",
  [string]$solutionPublisherDirectory = "C:\Program Files\SolutionPublisher",
  [string]$encodedUrlConfiguration = ""
  #[string]$rootPath = "C:\Temp\MiiWebServiceIntegrationSample",
  #[string]$buildNumber = "1.0.0.0",
  #[regex]$pattern = "\d+\.\d+\.\d+\.\d+",
  #[string]$patternSplitCharacters = ".",
  #[string]$solutionPublisherDirectory = "C:\TFSDefaultCollection\Visual Studio Tools\SolutionPublisher\SolutionPublisher\bin\Debug",
  #[string]$encodedUrlConfiguration = "%3C%3Fxml+version%3D%221.0%22+encoding%3D%22utf-8%22+%3F%3E%0D%0A%3CSolutionPublisherConfiguration%3E%0D%0A++%3CRootPath%3E%24rootPath%3C%2FRootPath%3E%0D%0A++%3CSnPath%3EC%3A%5CProgram+Files+%28x86%29%5CMicrosoft+SDKs%5CWindows%5Cv10.0A%5Cbin%5CNETFX+4.7+Tools%5Csn.exe%3C%2FSnPath%3E%0D%0A++%3CRegenSnkFiles%3Etrue%3C%2FRegenSnkFiles%3E%0D%0A++%3CRemoveReadOnlyAttributes%3Etrue%3C%2FRemoveReadOnlyAttributes%3E%0D%0A++%3CUnbindSourceControl%3Etrue%3C%2FUnbindSourceControl%3E%0D%0A++%3CDirectoriesToDelete%3E%0D%0A++++%3CSearchInfo%3E%0D%0A++++++%3CSearchPattern%3E.vs%3C%2FSearchPattern%3E%0D%0A++++++%3CSearchOption%3ETopDirectoryOnly%3C%2FSearchOption%3E%0D%0A++++%3C%2FSearchInfo%3E%0D%0A++++%3CSearchInfo%3E%0D%0A++++++%3CSearchPattern%3Ebin%3C%2FSearchPattern%3E%0D%0A++++++%3CSearchOption%3EAllDirectories%3C%2FSearchOption%3E%0D%0A++++%3C%2FSearchInfo%3E%0D%0A++++%3CSearchInfo%3E%0D%0A++++++%3CSearchPattern%3Eobj%3C%2FSearchPattern%3E%0D%0A++++++%3CSearchOption%3EAllDirectories%3C%2FSearchOption%3E%0D%0A++++%3C%2FSearchInfo%3E%0D%0A++++%3CSearchInfo%3E%0D%0A++++++%3CSearchPattern%3Epackages%3C%2FSearchPattern%3E%0D%0A++++++%3CSearchOption%3EAllDirectories%3C%2FSearchOption%3E%0D%0A++++%3C%2FSearchInfo%3E%0D%0A++%3C%2FDirectoriesToDelete%3E%0D%0A++%3CNugetSourcesToRemove%3E%0D%0A++++%3Cstring%3Esrvtfs%3C%2Fstring%3E%0D%0A++%3C%2FNugetSourcesToRemove%3E%0D%0A%3C%2FSolutionPublisherConfiguration%3E"
	)

if ($buildNumber -match $pattern -ne $true) {
    Write-Host "Could not extract a version from [$buildNumber] using pattern [$pattern]"
    exit 2
}

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

$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$rootPath' -replacement $rootPath
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$buildNumber' -replacement $buildNumber

# Run SolutionPublisher
$solutionPublisherPath = [System.IO.Path]::Combine($solutionPublisherDirectory,'SolutionPublisher.exe')

if (-Not [System.IO.File]::Exists($solutionPublisherPath)) {
    Write-Host "Could not find file [$solutionPublisherPath]"
    exit 3
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

exit $p.ExitCode