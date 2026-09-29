$ErrorActionPreference = 'Stop'
$stage = Join-Path $PWD 'build/FullerSpectrum'
foreach ($file in @('snapmaker-orca.exe', 'Snapmaker_Orca.dll', 'WebView2Loader.dll', 'resources/profiles', 'resources/images')) {
    if (-not (Test-Path (Join-Path $stage $file))) { throw "Required portable file missing: $file" }
}
New-Item -ItemType Directory -Force (Join-Path $stage 'data_dir') | Out-Null
$launcher = @'
@echo off
setlocal
cd /d "%~dp0"
if not exist "%~dp0data_dir" mkdir "%~dp0data_dir"
start "" "%~dp0snapmaker-orca.exe" --datadir "%~dp0data_dir" %*
'@
[IO.File]::WriteAllText((Join-Path $stage 'Run-FullerSpectrum-Portable.bat'), $launcher.Replace("`r`n", "`n").Replace("`n", "`r`n") + "`r`n", [Text.Encoding]::ASCII)
@'
Fuller Spectrum - Windows x64 portable
Extract this entire ZIP, then double-click Run-FullerSpectrum-Portable.bat.
Keep the executable, DLLs, resources and data_dir together.
Settings and profiles are stored in data_dir beside the launcher.

Use the existing Full Spectrum manual pattern controls. Assign the mixed filament
to both walls and solid infill. With 12,21, the outer wall, top/bottom surface,
exposed bridge skin and ironing use 12; inner walls and core use 21.
Each group still alternates by layer: 12 means A then B, repeating. For fixed
A outside and B inside, use 1,2. Swapping the groups reverses the assignment.
Additional wall groups preserve their existing inset order. Core follows the
innermost configured wall group (at least the second group for one-wall parts).
Explicit infill overrides still take precedence. Internal bridges remain core.
Actual appearance depends on filament opacity, shell thickness and lighting;
this feature controls tool routing and does not guarantee a measured color.
'@ | Set-Content (Join-Path $stage 'README-PORTABLE.txt') -Encoding utf8
"Source: https://github.com/$env:GITHUB_REPOSITORY/commit/$env:GITHUB_SHA`nBuild: $env:GITHUB_RUN_ID" |
    Set-Content (Join-Path $stage 'BUILD-INFO.txt') -Encoding utf8

# Test from the installed folder before packaging, so missing DLLs fail the job.
$process = Start-Process -FilePath (Join-Path $stage 'snapmaker-orca.exe') -ArgumentList '--help' -WorkingDirectory $stage -PassThru
if (-not $process.WaitForExit(60000)) {
    $process.Kill()
    throw 'Installed executable did not finish the startup smoke test'
}
if ($process.ExitCode -ne 0) { throw "Installed executable failed: $($process.ExitCode)" }

$zip = Join-Path $PWD 'FullerSpectrum-Windows-x64-Portable.zip'
& 'C:/Program Files/7-Zip/7z.exe' a -tzip $zip "$stage/*"
if ($LASTEXITCODE -ne 0) { throw 'ZIP creation failed' }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [IO.Compression.ZipFile]::OpenRead($zip)
try {
    $entries = @($archive.Entries | ForEach-Object { $_.FullName.Replace('\', '/') })
    foreach ($required in @('snapmaker-orca.exe', 'Snapmaker_Orca.dll', 'Run-FullerSpectrum-Portable.bat', 'data_dir/')) {
        if ($entries -notcontains $required) { throw "ZIP is missing $required" }
    }
    if (-not ($entries | Where-Object { $_ -like 'resources/profiles/*' })) { throw 'ZIP has no printer profiles' }
} finally { $archive.Dispose() }
Get-FileHash $zip -Algorithm SHA256 | Format-List
