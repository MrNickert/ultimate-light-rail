param([switch]$CheckOnly, [string]$PackageDirectory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archivePath = Join-Path $PackageDirectory 'downloads/ultimate-light-rail-1.0.0.zip'
$checksumPath = Join-Path $PackageDirectory 'downloads/SHA256SUMS.txt'
$targetRoot = [IO.Path]::GetFullPath('C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area\mrnickert_ultimate_metro')
$expectedChecksum = ((Get-Content -LiteralPath $checksumPath | Where-Object { $_ -match '  ultimate-light-rail-1\.0\.0\.zip$' }) -split '  ')[0]
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
        if (-not $relativeName -or $entry.FullName.EndsWith('/')) { continue }
        $destinationPath = [IO.Path]::GetFullPath((Join-Path $targetRoot $relativeName))
        if (-not $destinationPath.StartsWith($targetRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Archive entry escapes the mod directory.' }
        if ($relativeName -notin @('mod.json', 'strings.json') -and -not $relativeName.StartsWith('content/gui/', [StringComparison]::Ordinal)) { continue }
        $files += [PSCustomObject]@{Entry=$entry; Relative=$relativeName; Destination=$destinationPath}
    }
    $modEntry = $archive.GetEntry('mrnickert_ultimate_metro/mod.json')
    $reader = [IO.StreamReader]::new($modEntry.Open())
    try { $candidate = $reader.ReadToEnd() | ConvertFrom-Json } finally { $reader.Dispose() }
    if ($candidate.modId -ne 'mrnickert_ultimate_metro' -or $candidate.revision -ne 52) { throw 'Unexpected release candidate.' }
    if ($CheckOnly) { Write-Output ('Verified revision 52, checksum, target and ' + $files.Count + ' safe archive paths. No files changed.'); return }
    $backupRoot = Join-Path $PSScriptRoot ('staging-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
    foreach ($file in $files) {
        if (Test-Path -LiteralPath $file.Destination) {
            $backupPath = Join-Path $backupRoot $file.Relative
            New-Item -ItemType Directory -Path (Split-Path $backupPath -Parent) -Force | Out-Null
            Copy-Item -LiteralPath $file.Destination -Destination $backupPath
        }
        New-Item -ItemType Directory -Path (Split-Path $file.Destination -Parent) -Force | Out-Null
        if ($file.Relative -eq 'mod.json') {
            $currentDefinition = Get-Content -LiteralPath $file.Destination -Raw | ConvertFrom-Json
            $currentDefinition.revision = 52
            [IO.File]::WriteAllText($file.Destination, ($currentDefinition | ConvertTo-Json -Depth 100), [Text.UTF8Encoding]::new($false))
        } elseif ($file.Relative -eq 'strings.json') {
            $stringReader = [IO.StreamReader]::new($file.Entry.Open())
            try { $sourceStrings = $stringReader.ReadToEnd() | ConvertFrom-Json } finally { $stringReader.Dispose() }
            $currentStrings = Get-Content -LiteralPath $file.Destination -Raw | ConvertFrom-Json
            foreach ($language in $sourceStrings.PSObject.Properties) {
                $currentLanguage = $currentStrings.PSObject.Properties[$language.Name]
                if (-not $currentLanguage) {
                    $currentStrings | Add-Member -NotePropertyName $language.Name -NotePropertyValue $language.Value
                } else {
                    $currentLanguage.Value | Add-Member -NotePropertyName 'ULR_UI_SEARCH' -NotePropertyValue $language.Value.ULR_UI_SEARCH -Force
                }
            }
            [IO.File]::WriteAllText($file.Destination, ($currentStrings | ConvertTo-Json -Depth 100), [Text.UTF8Encoding]::new($false))
        } else {
            [IO.Compression.ZipFileExtensions]::ExtractToFile($file.Entry, $file.Destination, $true)
        }
    }
    Write-Output ('Updated local staging to revision 52. Backup: ' + $backupRoot)
    Write-Output 'Only UI files, the revision and one search-label translation were updated. Metadata, artwork, mod.io linkage and saves were preserved. Reload the test save with both mods active.'
} finally { $archive.Dispose() }
