param()
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path $PSScriptRoot -Parent
function Export-Presentation([string]$sourceName, [string]$outputName) {
    $sourcePath = Join-Path $projectRoot ('artwork/' + $sourceName)
    $outputPath = Join-Path $projectRoot ('publication/media/' + $outputName)
    $sourceImage = [Drawing.Image]::FromFile($sourcePath)
    $canvasImage = New-Object Drawing.Bitmap 1920,1080
    $canvasGraphics = [Drawing.Graphics]::FromImage($canvasImage)
    try {
        $canvasGraphics.Clear([Drawing.Color]::FromArgb(10,30,44))
        $canvasGraphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $scaleFactor = [Math]::Min(1920.0 / $sourceImage.Width, 1080.0 / $sourceImage.Height)
        $imageWidth = [int][Math]::Round($sourceImage.Width * $scaleFactor)
        $imageHeight = [int][Math]::Round($sourceImage.Height * $scaleFactor)
        $canvasGraphics.DrawImage($sourceImage, [int]((1920-$imageWidth)/2), [int]((1080-$imageHeight)/2), $imageWidth, $imageHeight)
        $canvasImage.Save($outputPath, [Drawing.Imaging.ImageFormat]::Png)
    } finally { $canvasGraphics.Dispose(); $canvasImage.Dispose(); $sourceImage.Dispose() }
}
Export-Presentation 'publication-cover-source.png' 'cover.png'
Export-Presentation 'publication-api-source.png' 'api-overview.png'
$galleryMapping = @{
    '0.png'='cover.png'; '1.png'='cover.png'; '2.png'='api-overview.png';
    '3.png'='gameplay-elevated.png'; '4.png'='gameplay-fenced-crossing.png'
}
foreach ($fileName in $galleryMapping.Keys) {
    Copy-Item -LiteralPath (Join-Path $projectRoot ('publication/media/' + $galleryMapping[$fileName])) -Destination (Join-Path $projectRoot ('_metadata/' + $fileName)) -Force
}
Write-Output 'Cover and API presentation exported at 1920x1080; four gallery images prepared.'
