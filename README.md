

# VSCacheCleaner - Visual Studio Cache Cleaner Powershell Script

## Overview
`VSCacheCleaner` is a PowerShell script designed to clean Visual Studio cache directories and perform a repair operation using `vswhere.exe` and `setup.exe`. This script helps maintain a clean development environment and ensures Visual Studio runs smoothly.

## Features
- **Close Visual Studio**: Automatically closes Visual Studio if it's running.
- **Clean Cache Directories**: Deletes cache directories to free up space and resolve potential issues.
- **Repair Visual Studio**: Uses `vswhere.exe` to locate Visual Studio instances and `setup.exe` to perform repair operations.

## Prerequisites
- **PowerShell**: Ensure you have PowerShell installed on your system.
- **vswhere.exe**: Download and place `vswhere.exe` in a known location. You can get it from the Visual Studio tools page.

## Usage
1. **Clone the Repository**:
    ```sh
    git clone https://github.com/yourusername/VSCacheCleaner.git
    cd VSCacheCleaner
    ```

2. **Run the Script**:
    ```powershell
    .\Clean-VSCache.ps1
    ```

## Script Details
The script performs the following actions:
1. **Close Visual Studio**:
    ```powershell
    Stop-Process -Name devenv -Force -ErrorAction SilentlyContinue
    ```

2. **Define Cache Directories**:
    ```powershell
    $cacheDirs = @(
        "$env:LOCALAPPDATA\Microsoft\VisualStudio",
        "$env:LOCALAPPDATA\Microsoft\VSCommon",
        "$env:LOCALAPPDATA\Temp",
        "$env:LOCALAPPDATA\Microsoft\VisualStudio\Roslyn"
    )
    ```

3. **Delete Cache Directories**:
    ```powershell
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
    ```

4. **Run Visual Studio Installer to Repair**:
    ```powershell
    $setupExePath = "C:\Path\To\VisualStudio\setup.exe"
    $channelId = "VisualStudio.16.Release"
    $productId = "Microsoft.VisualStudio.Product.Enterprise"
    $installPath = "C:\Path\To\VisualStudio"

    Start-Process -FilePath $setupExePath -ArgumentList "repair --channelId $channelId --productId $productId --installPath $installPath"
    ```

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License
This project is licensed under the MIT License.
