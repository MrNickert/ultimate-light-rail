$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $projectRoot 'ui-preview/artwork/light_rail_icon.png'
$targetPath = Join-Path $projectRoot 'ui-preview/content/gui/light_rail.tga'
$bitmap = [System.Drawing.Bitmap]::new($sourcePath)
try {
    $bytes = [byte[]]::new(18 + $bitmap.Width * $bitmap.Height * 4)
    $bytes[2] = 2
    [BitConverter]::GetBytes([uint16]$bitmap.Width).CopyTo($bytes,12)
    [BitConverter]::GetBytes([uint16]$bitmap.Height).CopyTo($bytes,14)
    $bytes[16] = 32
    $bytes[17] = 40
    $offset = 18
    for ($y=0; $y -lt $bitmap.Height; $y++) {
        for ($x=0; $x -lt $bitmap.Width; $x++) {
            $pixel = $bitmap.GetPixel($x,$y)
            $bytes[$offset] = $pixel.B
            $bytes[$offset+1] = $pixel.G
            $bytes[$offset+2] = $pixel.R
            $bytes[$offset+3] = $pixel.A
            $offset += 4
        }
    }
    [IO.File]::WriteAllBytes($targetPath,$bytes)
    Write-Output "Converted supplied icon to TGA without cropping, recolouring or resizing: $($bitmap.Width)x$($bitmap.Height)"
} finally { $bitmap.Dispose() }
