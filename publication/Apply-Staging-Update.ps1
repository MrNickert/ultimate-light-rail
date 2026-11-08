param([switch]$CheckOnly)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archiveName = 'ultimate-light-rail-1.3.0.zip'
$archivePath = Join-Path $PSScriptRoot "downloads/$archiveName"
$checksumPath = Join-Path $PSScriptRoot 'downloads/SHA256SUMS.txt'
$checksums = @(Get-Content -LiteralPath $checksumPath | Where-Object {
    $_.EndsWith('  ' + $archiveName, [StringComparison]::Ordinal)
})
if ($checksums.Count -ne 1) { throw 'Missing or duplicate core archive checksum.' }
$expected = ($checksums[0] -split '  ', 2)[0]
if ((Get-FileHash -LiteralPath $archivePath).Hash -ne $expected) { throw 'Core archive checksum mismatch.' }

$modId = 'mrnickert_ultimate_metro'
$target = 'C:\Program Files (x86)\Steam\userdata\87691647\3493540\local\staging_area\mrnickert_ultimate_metro'
$mod = Get-Content -LiteralPath (Join-Path $target 'mod.json') -Raw | ConvertFrom-Json
if ($mod.modId -ne $modId -or $mod.revision -notin @(73, 74, 75, 76, 77, 78)) {
    throw "Unexpected staging mod '$($mod.modId)' or revision '$($mod.revision)'. Expected ULR revision 73 through 78."
}

$retired = @(
    'content/aboveground_interchange.con.lua',
    'content/aboveground_interchange.script.lua',
    'content/aboveground_interchange_util.lua',
    'content/mixed_interchange.con.lua',
    'content/mixed_interchange.script.lua'
)
$archive = [IO.Compression.ZipFile]::OpenRead($archivePath)
try {
    $prefix = "$modId/"
    $runtimePaths = @($archive.Entries | ForEach-Object {
        if (-not $_.FullName.StartsWith($prefix, [StringComparison]::Ordinal)) { throw 'Unexpected archive root.' }
        $path = $_.FullName.Substring($prefix.Length)
        if ($path.StartsWith('content/', [StringComparison]::Ordinal)) {
            if ($path -notmatch '^content/(?:[a-z0-9_-]+/)*[a-z0-9_-]+(?:\.[a-z0-9_-]+)+$' -or $path -in $retired) {
                throw "Unexpected runtime path: $path"
            }
            $path
        }
    })
    $modEntry = $archive.GetEntry("${prefix}mod.json")
    if (-not $modEntry) { throw 'Missing archive mod.json.' }
    $reader = [IO.StreamReader]::new($modEntry.Open())
    try { $candidate = $reader.ReadToEnd() | ConvertFrom-Json } finally { $reader.Dispose() }
    if ($candidate.modId -ne $modId -or $candidate.revision -ne 78) { throw 'Unexpected release candidate.' }

    # Update mod.json after content, while leaving all listing metadata in place.
    $expectedRuntime = $runtimePaths + @('strings.json', 'credits.txt', 'mod.json')
    $updates = @()
    $sha256 = [Security.Cryptography.SHA256]::Create()
    try {
        foreach ($path in $expectedRuntime) {
            $entry = $archive.GetEntry("$prefix$path")
            if (-not $entry) { throw "Missing $path in the archive." }
            $current = Join-Path $target $path
            if (-not (Test-Path -LiteralPath $current -PathType Leaf)) { $updates += $path; continue }
            $stream = $entry.Open()
            try { $hash = [BitConverter]::ToString($sha256.ComputeHash($stream)).Replace('-', '') }
            finally { $stream.Dispose() }
            if ((Get-FileHash -LiteralPath $current).Hash -ne $hash) { $updates += $path }
        }
    } finally { $sha256.Dispose() }

    $removals = @($retired | Where-Object { Test-Path -LiteralPath (Join-Path $target $_) -PathType Leaf })
    $paths = $removals + $updates
    foreach ($path in $paths) {
        if (-not (Test-Path -LiteralPath (Split-Path -Parent (Join-Path $target $path)) -PathType Container)) {
            throw "Missing staging directory for $path."
        }
    }
    if ($CheckOnly) {
        Write-Output "Verified staging revision $($mod.revision). Files to update: $($updates.Count). Prototype files to remove: $($removals.Count)."
        return
    }
    if ($paths.Count -eq 0) { Write-Output 'Staging already matches Ultimate Light Rail 1.3.0.'; return }

    $backup = Join-Path $PSScriptRoot ('staging-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
    foreach ($path in $paths) {
        $current = Join-Path $target $path
        if (Test-Path -LiteralPath $current -PathType Leaf) {
            $saved = Join-Path $backup $path
            New-Item -ItemType Directory -Path (Split-Path -Parent $saved) -Force | Out-Null
            Copy-Item -LiteralPath $current -Destination $saved
        }
    }

    $attempted = @()
    try {
        foreach ($path in $paths) {
            $attempted += $path
            $destination = Join-Path $target $path
            if ($path -in $removals) {
                Remove-Item -LiteralPath $destination
            } else {
                [IO.Compression.ZipFileExtensions]::ExtractToFile($archive.GetEntry("$prefix$path"), $destination, $true)
            }
        }
    } catch {
        foreach ($path in $attempted) {
            $saved = Join-Path $backup $path
            $current = Join-Path $target $path
            if (Test-Path -LiteralPath $saved -PathType Leaf) {
                Copy-Item -LiteralPath $saved -Destination $current -ErrorAction Continue
            } elseif (Test-Path -LiteralPath $current -PathType Leaf) {
                Remove-Item -LiteralPath $current -ErrorAction Continue
            }
        }
        throw
    }
    Write-Output "Staged Ultimate Light Rail 1.3.0 (revision 78). Prototype files removed: $($removals.Count). Backup: $backup"
    Write-Output 'Refresh the Mod Hub and run validation before uploading.'
} finally { $archive.Dispose() }
