param([switch]$CheckOnly)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archivePath = Join-Path $PSScriptRoot 'downloads/ultimate-light-rail-1.2.2.zip'
$checksumPath = Join-Path $PSScriptRoot 'downloads/SHA256SUMS.txt'
$targetRoot = [IO.Path]::GetFullPath('C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area\mrnickert_ultimate_metro')
$expectedChecksum = ((Get-Content -LiteralPath $checksumPath | Where-Object { $_.EndsWith('  ' + [IO.Path]::GetFileName($archivePath), [StringComparison]::Ordinal) }) -split '  ')[0]
if ((Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expectedChecksum) { throw 'Archive checksum mismatch.' }
if (Test-Path -LiteralPath (Join-Path $targetRoot 'mod.json')) {
    $installed = Get-Content -LiteralPath (Join-Path $targetRoot 'mod.json') -Raw | ConvertFrom-Json
    if ($installed.modId -ne 'mrnickert_ultimate_metro') { throw 'Unexpected installed mod ID.' }
}
$archive = [IO.Compression.ZipFile]::OpenRead($archivePath)
try {
    $files = @()
    foreach ($entry in $archive.Entries) {
        $prefix = 'mrnickert_ultimate_metro/'
        if (-not $entry.FullName.StartsWith($prefix, [StringComparison]::Ordinal)) { throw 'Unexpected archive root.' }
        $relativeName = $entry.FullName.Substring($prefix.Length)
        if (-not $relativeName -or $entry.FullName.EndsWith('/') -or $relativeName.StartsWith('_metadata/', [StringComparison]::OrdinalIgnoreCase)) { continue }
        $destinationPath = [IO.Path]::GetFullPath((Join-Path $targetRoot $relativeName))
        if (-not $destinationPath.StartsWith($targetRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Archive entry escapes the mod directory.' }
        $files += [PSCustomObject]@{Entry=$entry; Relative=$relativeName; Destination=$destinationPath}
    }
    $modEntry = $archive.GetEntry('mrnickert_ultimate_metro/mod.json')
    $reader = [IO.StreamReader]::new($modEntry.Open())
    try { $candidate = $reader.ReadToEnd() | ConvertFrom-Json } finally { $reader.Dispose() }
    if ($candidate.modId -ne 'mrnickert_ultimate_metro' -or $candidate.revision -ne 73) { throw 'Unexpected release candidate.' }
    if ($CheckOnly) { Write-Output ('Verified revision 73, checksum, target and ' + $files.Count + ' safe archive paths. No files changed.'); return }
    $backupRoot = Join-Path $PSScriptRoot ('staging-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
    foreach ($file in $files) {
        if (Test-Path -LiteralPath $file.Destination) {
            $backupPath = Join-Path $backupRoot $file.Relative
            New-Item -ItemType Directory -Path (Split-Path $backupPath -Parent) -Force | Out-Null
            Copy-Item -LiteralPath $file.Destination -Destination $backupPath
        }
        New-Item -ItemType Directory -Path (Split-Path $file.Destination -Parent) -Force | Out-Null
        [IO.Compression.ZipFileExtensions]::ExtractToFile($file.Entry, $file.Destination, $true)
    }
    Write-Output ('Updated local staging to revision 73. Backup: ' + $backupRoot)
    Write-Output 'Existing mod.io metadata, linkage and saves were preserved. Refresh the Mod Hub and rerun validation.'
} finally { $archive.Dispose() }
