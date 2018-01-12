Param(
  [string]$pathToSearch = $env:BUILD_SOURCESDIRECTORY,
  [string]$buildNumber = $env:BUILD_BUILDNUMBER,
  [regex]$pattern = "\d+\.\d+\.\d+\.\d+",
  [string]$patternSplitCharacters = "."
)

$ErrorActionPreference = "Stop"

$searchFilter = "*.vbproj;*.csproj"
if ($buildNumber -match $pattern -ne $true) {
    Write-Host "Could not extract a version from [$buildNumber] using pattern [$pattern]"
    exit 2
}

# Declare functions

function Replace-Pattern($content, $pattern, $replacement) {

    $patternReplaced = $false

    $content = $content | %{
        if ($_ -cmatch $pattern) {
            $patternReplaced = $true
            Write-Host "     * Replaced $($Matches[0]) with $replacement"
            $_ = $_ -replace [regex]::Escape($Matches[0]),$replacement
        }
        $_
    }
	
    if (-not $patternReplaced) {
        Write-Host "     * Pattern $pattern not found"
    }

    return $content
}

function Get-VersionString($numberOfVersions, $extractedBuildNumbers) {
    return [string]::Join(".",($extractedBuildNumbers | select -First ([int]::Parse($numberOfVersions))))
}

# Set version variables
$extractedBuildNumbers = @($Matches[0].Split(([char[]]$patternSplitCharacters)))
if ($extractedBuildNumbers.Length -ne 4) {
    Write-Host "The extracted build number $($Matches[0]) does not contain the expected 4 elements"
    exit 2
}
$dotFileVersion = Get-VersionString -separator "." -numberOfVersions "3" -extractedBuildNumbers $extractedBuildNumbers

Write-Host "Using file version $dotFileVersion"

gci -Path $pathToSearch -Filter $searchFilter -Recurse | %{
    Write-Host "  -> Changing $($_.FullName)"
         
    # remove the read-only bit on the file
    sp $_.FullName IsReadOnly $false
 
    # run the regex replace
    $content = gc $_.FullName
    $content = Replace-Pattern -content $content -pattern '\<Version\>.*\<\/Version\>' -replacement "\<Version\>$dotFileVersion\<\/Version\>"
	$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
	[System.IO.File]::WriteAllLines($_.FullName, $content, $Utf8NoBomEncoding)
}
Write-Host "Done!"
