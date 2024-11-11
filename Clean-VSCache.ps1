# Close Visual Studio if it's running
Stop-Process -Name devenv -Force -ErrorAction SilentlyContinue

# Define cache directories
$cacheDirs = @(
    "$env:LOCALAPPDATA\Microsoft\VisualStudio",
    "$env:LOCALAPPDATA\Microsoft\VSCommon",
    "$env:LOCALAPPDATA\Temp",
    "$env:LOCALAPPDATA\Microsoft\VisualStudio\Roslyn"
)

# Delete cache directories
foreach ($dir in $cacheDirs) {
    if (Test-Path $dir) {
        try {
            Remove-Item $dir -Recurse -Force -ErrorAction Stop
            Write-Output "Deleted cache directory: $dir"
        } catch {
            Write-Output "Failed to delete cache directory: $dir. Error: $_"
        }
    } else {
        Write-Output "Cache directory not found: $dir"
    }
}

# Path to vswhere.exe
$vswherePath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

# Get Visual Studio instances and select channelId and productId
$vsInstances = & $vswherePath -format json | ConvertFrom-Json
$vsInstance = $vsInstances | Select-Object -First 1

$channelId = $vsInstance.catalog.id
$productId = $vsInstance.productId

Write-Output "run Visual Studio Installer to repair"
Write-Output "ChannelId: $channelId"
Write-Output "ProductId: $productId"

# Path to setup.exe
$setupExePath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe"

# Run the repair command
Start-Process -FilePath $setupExePath -ArgumentList "repair --channelId $channelId --productId $productId"
