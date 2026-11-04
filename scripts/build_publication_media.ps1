$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $projectRoot 'publication/media/gameplay-elevated.png'
$source = [System.Drawing.Bitmap]::new($sourcePath)
$cover = [System.Drawing.Bitmap]::new(1920,1080)
$graphics = [System.Drawing.Graphics]::FromImage($cover)
$white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
$cyan = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#76dfd2'))
$muted = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#b9d8de'))
$title = [System.Drawing.Font]::new('Segoe UI',76,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Pixel)
$body = [System.Drawing.Font]::new('Segoe UI',24,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
$version = [System.Drawing.Font]::new('Segoe UI',36,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Pixel)
try {
    if ($source.Width -ne 1911 -or $source.Height -ne 849) { throw 'Update the vector frame dimensions for a different source image.' }
    $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml('#102635'))
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $graphics.FillRectangle($cyan,46,30,7,88)
    $graphics.DrawString('Ultimate Light Rail',$title,$white,75,19)
    $graphics.DrawString('Surface · Underground · Elevated',$body,$muted,79,105)
    $graphics.DrawString('1.0.0',$version,$cyan,1730,40)
    $graphics.DrawImageUnscaled($source,4,150)
    $graphics.DrawString('Reversing terminus stations · Native tram connections',$body,$muted,48,1018)
    $graphics.DrawString('Available from 1925',$body,$cyan,1520,1018)
    # Compare every gameplay pixel in the rendered cover. Only the surrounding
    # code-native typography/background is new; the capture itself is unchanged.
    $readOnly = [System.Drawing.Imaging.ImageLockMode]::ReadOnly
    $format = [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    $srcData = $source.LockBits([System.Drawing.Rectangle]::new(0,0,1911,849),$readOnly,$format)
    $dstData = $cover.LockBits([System.Drawing.Rectangle]::new(4,150,1911,849),$readOnly,$format)
    try {
        $srcRow = [byte[]]::new(1911*4)
        $dstRow = [byte[]]::new(1911*4)
        for ($row=0; $row -lt 849; $row++) {
            [Runtime.InteropServices.Marshal]::Copy([IntPtr]::Add($srcData.Scan0,$row*$srcData.Stride),$srcRow,0,$srcRow.Length)
            [Runtime.InteropServices.Marshal]::Copy([IntPtr]::Add($dstData.Scan0,$row*$dstData.Stride),$dstRow,0,$dstRow.Length)
            if ([Convert]::ToBase64String($srcRow) -cne [Convert]::ToBase64String($dstRow)) { throw "Gameplay pixels changed on row $row" }
        }
    } finally { $source.UnlockBits($srcData); $cover.UnlockBits($dstData) }
    $cover.Save((Join-Path $projectRoot 'publication/media/cover.png'),[System.Drawing.Imaging.ImageFormat]::Png)
    $cover.Save((Join-Path $projectRoot '_metadata/0.png'),[System.Drawing.Imaging.ImageFormat]::Png)
} finally {
    $version.Dispose(); $body.Dispose(); $title.Dispose()
    $muted.Dispose(); $cyan.Dispose(); $white.Dispose()
    $graphics.Dispose(); $cover.Dispose(); $source.Dispose()
}
Write-Output 'Built 1920x1080 cover; verified every embedded gameplay pixel unchanged.'
