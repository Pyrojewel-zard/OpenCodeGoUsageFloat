$ErrorActionPreference = 'Stop'

Get-ChildItem -Path .\src -Filter 'main.go.part*' | Sort-Object Name | ForEach-Object {
    Get-Content $_.FullName -Raw
} | Set-Content -Path .\main.go -Encoding utf8

$env:GOOS = 'windows'
$env:GOARCH = 'amd64'
$env:CGO_ENABLED = '0'

go vet ./...
go build -trimpath -ldflags '-H windowsgui -s -w' -o OpenCodeGoUsage.exe .

Write-Host 'Built: OpenCodeGoUsage.exe'
