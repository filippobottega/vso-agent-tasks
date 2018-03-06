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

$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$rootPath' -replacement $rootPath
$encodedUrlConfiguration = Replace-Tag -encodedContent $encodedUrlConfiguration -tagName '$buildVersion' -replacement $buildVersion

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