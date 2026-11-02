$ErrorActionPreference = "Stop"

$driverVersion = "13.6.0"
$archivePath = Join-Path $env:USERPROFILE ".m2\repository\com\microsoft\sqlserver\sqljdbc_$driverVersion.0_enu.zip"
$downloadUrl = "https://download.microsoft.com/download/c68a946f-d56d-44a4-b89e-96c4b1004832/sqljdbc_13.6.0.0_enu.zip"

if (-not (Test-Path -LiteralPath $archivePath)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $archivePath) | Out-Null
    Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$nativeDirectory = Join-Path $PSScriptRoot "..\target\native"
New-Item -ItemType Directory -Force -Path $nativeDirectory | Out-Null
$archive = [System.IO.Compression.ZipFile]::OpenRead($archivePath)
try {
    $entry = $archive.Entries | Where-Object { $_.Name -like "mssql-jdbc_auth-$driverVersion.x64.dll" } | Select-Object -First 1
    if ($null -eq $entry) { throw "No matching Windows authentication DLL was found in the Microsoft driver archive." }
    $dllPath = Join-Path $nativeDirectory $entry.Name
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $dllPath, $true)
} finally {
    $archive.Dispose()
}

$env:PATH = "$nativeDirectory;$env:PATH"
mvn spring-boot:run
exit $LASTEXITCODE