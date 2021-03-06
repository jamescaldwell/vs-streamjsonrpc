<#
.SYNOPSIS
    Installs a NuGet package.
.PARAMETER PackageID
    The Package ID to install.
.PARAMETER Version
    The version of the package to install. If unspecified, the latest stable release is installed.
.PARAMETER Source
    The package source feed to find the package to install from.
.PARAMETER PackagesDir
    The directory to install the package to. By default, it uses the Packages folder at the root of the repo.
#>
Param(
    [Parameter(Position=1,Mandatory=$true)]
    [string]$PackageId,
    [Parameter()]
    [string]$Version,
    [Parameter()]
    [string]$Source,
    [Parameter()]
    [string]$PackagesDir="$PSScriptRoot\..\packages"
)

$nugetPath = & "$PSScriptRoot\Get-NuGetTool.ps1"

if (!(Test-Path $PackagesDir)) { $null = md $PackagesDir }
Push-Location $PackagesDir
try {
    Write-Verbose "Installing $PackageId..."
    $args = "Install",$PackageId
    if ($Version) { $args += "-Version",$Version }
    if ($Source) { $args += "-Source",$Source }
    Invoke-Expression "$nugetPath $([string]::Join(' ', $args))"
    if ($lastexitcode -ne 0) { throw }
} finally {
    Pop-Location
}
