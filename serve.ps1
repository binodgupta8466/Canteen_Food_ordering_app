param(
    [int]$Port = 8080
)

$webRoot = Join-Path $PSScriptRoot "build\web"
if (-not (Test-Path $webRoot)) {
    Write-Error "Web directory not found at $webRoot"
    exit 1
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()

Write-Host "==========================================================" -ForegroundColor Green
Write-Host " CampusBite Canteen App - Live Web Server Running!        " -ForegroundColor Yellow
Write-Host " URL: http://localhost:$Port/                             " -ForegroundColor Cyan
Write-Host " Serving from: $webRoot                                   " -ForegroundColor Gray
Write-Host " Press Ctrl+C to stop the server                          " -ForegroundColor DarkGray
Write-Host "==========================================================" -ForegroundColor Green

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $localPath = $request.Url.LocalPath
        if ($localPath -eq "/" -or [string]::IsNullOrEmpty($localPath)) {
            $localPath = "/index.html"
        }

        $filePath = Join-Path $webRoot ($localPath.TrimStart('/'))

        if (Test-Path $filePath -PathType Leaf) {
            $contentBytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentType = "text/html"
            $response.ContentLength64 = $contentBytes.Length
            $response.OutputStream.Write($contentBytes, 0, $contentBytes.Length)
        } else {
            $response.StatusCode = 404
            $notFoundBytes = [System.Text.Encoding]::UTF8.GetBytes("File Not Found")
            $response.OutputStream.Write($notFoundBytes, 0, $notFoundBytes.Length)
        }
        $response.Close()
    }
} finally {
    $listener.Stop()
}
