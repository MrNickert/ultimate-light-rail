param([switch]$CheckOnly, [string]$PackageDirectory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archivePath = Join-Path $PackageDirectory 'downloads/ultimate-light-rail-1.1.0.zip'
$checksumPath = Join-Path $PackageDirectory 'downloads/SHA256SUMS.txt'
$targetRoot = [IO.Path]::GetFullPath('C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area\mrnickert_ultimate_metro')
$expectedChecksum = ((Get-Content -LiteralPath $checksumPath | Where-Object { $_ -match '  ultimate-light-rail-1\.1\.0\.zip$' }) -split '  ')[0]
if ((Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expectedChecksum) { throw 'Archive checksum mismatch.' }
$installedDefinition = Join-Path $targetRoot 'mod.json'
if (-not (Test-Path -LiteralPath $installedDefinition -PathType Leaf)) {
    throw "Existing Ultimate Light Rail staging installation not found: $installedDefinition"
}
$installed = Get-Content -LiteralPath $installedDefinition -Raw | ConvertFrom-Json
if ($installed.modId -ne 'mrnickert_ultimate_metro') { throw 'Unexpected installed mod ID.' }
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
        if ($relativeName -notin @('mod.json', 'strings.json', 'content/station_turnback_track.lua', 'content/terminus_util.lua', 'content/through_station_util.lua', 'content/surface_station_util.lua', 'content/station_api_v1.lua', 'content/station_config_util.lua', 'content/station_layout_builder.lua', 'content/station_menu.script.lua', 'content/underground_entrance_util.lua', 'content/underground_concourse_util.lua', 'content/underground_interchange.con.lua', 'content/ui/underground_interchange.tga', 'content/underground_interchange_four_test.con.lua', 'content/underground_interchange.script.lua', 'content/light_rail_station.con.lua', 'content/ui/lightrail_fenced.tga', 'content/ui/light_rail_station.tga', 'content/ui/light_rail_station_preview.tga', 'content/underground_station_util.lua', 'content/elevated_station_util.lua', 'content/underground_terminus.con.lua', 'content/underground_terminus.script.lua', 'content/maintenance_migration.gs.lua', 'content/maintenance_migration.script.lua')) { continue }
        $files += [PSCustomObject]@{Entry=$entry; Relative=$relativeName; Destination=$destinationPath}
    }
    $modEntry = $archive.GetEntry('mrnickert_ultimate_metro/mod.json')
    $reader = [IO.StreamReader]::new($modEntry.Open())
    try { $candidate = $reader.ReadToEnd() | ConvertFrom-Json } finally { $reader.Dispose() }
    if ($candidate.modId -ne 'mrnickert_ultimate_metro' -or $candidate.revision -ne 65) { throw 'Unexpected release candidate.' }
    if ($CheckOnly) { Write-Output ('Verified revision 65, checksum, target and ' + $files.Count + ' safe archive paths. No files changed.'); return }
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
            $currentDefinition.revision = 65
            [IO.File]::WriteAllText($file.Destination, ($currentDefinition | ConvertTo-Json -Depth 100), [Text.UTF8Encoding]::new($false))
        } else {
            [IO.Compression.ZipFileExtensions]::ExtractToFile($file.Entry, $file.Destination, $true)
        }
    }
    Write-Output ('Updated local staging to revision 65. Backup: ' + $backupRoot)
    Write-Output 'Underground Interchange test build installed; metadata, artwork, UI and mod.io linkage preserved. Reload your save and let the simulation run to migrate existing stations.'
} finally { $archive.Dispose() }
