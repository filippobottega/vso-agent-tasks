Param(
  [string]$pathToSearch = $env:BUILD_SOURCESDIRECTORY,
  [string]$buildNumber = $env:BUILD_BUILDNUMBER,
  [regex]$pattern = "\d+\.\d+\.\d+\.\d+",
  [string]$patternSplitCharacters = "."
)

$ErrorActionPreference = "Stop"

$searchFilter = "*.rc"
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

function Get-VersionString($separator, $numberOfVersions, $extractedBuildNumbers) {
    return [string]::Join($separator,($extractedBuildNumbers | select -First ([int]::Parse($numberOfVersions))))
}

# Set version variables
$extractedBuildNumbers = @($Matches[0].Split(([char[]]$patternSplitCharacters)))
if ($extractedBuildNumbers.Length -ne 4) {
    Write-Host "The extracted build number $($Matches[0]) does not contain the expected 4 elements"
    exit 2
}

$dotFileVersion = Get-VersionString -separator "." -numberOfVersions "4" -extractedBuildNumbers $extractedBuildNumbers
$commaFileVersion = Get-VersionString -separator "," -numberOfVersions "4" -extractedBuildNumbers $extractedBuildNumbers

Write-Host "Using file version $dotFileVersion"

gci -Path $pathToSearch -Filter $searchFilter -Recurse | %{
    Write-Host "  -> Changing $($_.FullName)"
         
    # remove the read-only bit on the file
    sp $_.FullName IsReadOnly $false
 
    # run the regex replace
    $content = gc $_.FullName
    $content = Replace-Pattern -content $content -pattern 'FILEVERSION.*$' -replacement "FILEVERSION $commaFileVersion"
    $content = Replace-Pattern -content $content -pattern 'PRODUCTVERSION.*$' -replacement "PRODUCTVERSION $commaFileVersion"
    $content = Replace-Pattern -content $content -pattern 'VALUE "FileVersion",.*$' -replacement "VALUE ""FileVersion"", ""$dotFileVersion"""
    $content = Replace-Pattern -content $content -pattern 'VALUE "ProductVersion",.*$' -replacement "VALUE ""ProductVersion"", ""$dotFileVersion"""
    $content | sc $_.FullName -Encoding UTF8
}
Write-Host "Done!"
