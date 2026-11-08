$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path -Parent $PSScriptRoot

function Write-IconTga([System.Drawing.Bitmap]$source, [int]$size, [string]$destination, [string]$previewPath) {
    $small = [System.Drawing.Bitmap]::new($size,$size)
    $smallGraphics = [System.Drawing.Graphics]::FromImage($small)
    try {
        $smallGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $smallGraphics.DrawImage($source,0,0,$size,$size)
        if ($previewPath) { $small.Save($previewPath,[System.Drawing.Imaging.ImageFormat]::Png) }
        $bytes = [byte[]]::new(18+$size*$size*4)
        $bytes[2]=2
        [BitConverter]::GetBytes([uint16]$size).CopyTo($bytes,12)
        [BitConverter]::GetBytes([uint16]$size).CopyTo($bytes,14)
        $bytes[16]=32; $bytes[17]=40
        $offset=18
        for ($y=0;$y -lt $size;$y++) {
            for ($x=0;$x -lt $size;$x++) {
                $pixel=$small.GetPixel($x,$y)
                $bytes[$offset]=255; $bytes[$offset+1]=255; $bytes[$offset+2]=255
                $bytes[$offset+3]=$pixel.A
                $offset+=4
            }
        }
        [IO.File]::WriteAllBytes($destination,$bytes)
    } finally { $smallGraphics.Dispose(); $small.Dispose() }
}

# Vector geometry based on the supplied side-profile: white mask, transparent
# windows/background. Native ToolButton styles supply the displayed colour.
$large = [System.Drawing.Bitmap]::new(120,120)
$graphics = [System.Drawing.Graphics]::FromImage($large)
$body = [System.Drawing.Drawing2D.GraphicsPath]::new()
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::White,1.6)
$pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
try {
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.ScaleTransform(4,4)
    $body.StartFigure()
    $body.AddLine(3,22,3,12)
    $body.AddBezier(3,12,3,10,4,9,6,9)
    $body.AddLine(6,9,19,9)
    $body.AddBezier(19,9,21,9,22,10,23,12)
    $body.AddLine(23,12,27,19)
    $body.AddBezier(27,19,28,21,27,22,25,22)
    $body.CloseFigure()
    # Alternate fill cuts the windows out of the white body.
    $body.AddRectangle([System.Drawing.RectangleF]::new(5,11.5,12,8))
    $body.StartFigure()
    $body.AddLine(19,11.5,21,11.5)
    $body.AddLine(21,11.5,25.5,19.5)
    $body.AddLine(25.5,19.5,19,19.5)
    $body.CloseFigure()
    $graphics.FillPath([System.Drawing.Brushes]::White,$body)
    $graphics.DrawLine($pen,10,5,18,5)
    $graphics.DrawLine($pen,14,5,14,9)
    $graphics.DrawLine($pen,3,25,27,25)
    Write-IconTga $large 30 (Join-Path $projectRoot 'content/gui/light_rail.tga') (Join-Path $projectRoot 'dist/light-rail-menu-icon.png')
    Write-IconTga $large 18 (Join-Path $projectRoot 'content/gui/light_rail_line_filter.tga')
} finally { $pen.Dispose(); $body.Dispose(); $graphics.Dispose(); $large.Dispose() }
Write-Output 'Rendered transparent Light Rail icons for the toolbar (30 px) and line filter (18 px).'
