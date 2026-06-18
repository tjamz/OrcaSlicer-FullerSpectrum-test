
<h1> <p "font-size:200px;"> Snapmaker Orca Full(er) Spectrum</p> </h1>

### A Snapmaker Orca Fork with Fuller Mixed-Color Filament Support

[![Build all](https://github.com/Snapmaker/OrcaSlicer/actions/workflows/build_all.yml/badge.svg?branch=main)](https://github.com/Snapmaker/OrcaSlicer/actions/workflows/build_all.yml)

---

## ☕ Support Development

If you find this fun or interesting!

<a href="https://www.buymeacoffee.com/ratdoux" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

---

## ⚠️ **IMPORTANT DISCLAIMER** ⚠️

**This fork is currently in active development and has been tested on actual hardware.**

- **Use at Your Own Risk**: As with any slicer fork, please review critical prints and generated G-code before production use
- **Project Compatibility Warning**: Some `.3mf` files created with older FullSpectrum builds may not open or migrate cleanly in newer versions because mixed-filament data and project serialization have changed over time

---

**Snapmaker Orca Full(er) Spectrum** is an open source slicer for FDM printers based on Snapmaker Orca and OrcaSlicer, optimized for Snapmaker's U1 multi-color 3D printer with independent tool heads. This fork builds on the original FullSpectrum concept by adding virtual mixed-color filaments plus a new shell-blend mode that uses the visible outer wall and the next inner wall to make two real filament colors appear more like a third blended color.
 


# Download

### Stable Release
📥 **[Download the Latest Release](https://github.com/tjamz/OrcaSlicer-FullerSpectrum-test/releases)**  
Visit the GitHub Releases page for the latest build of Snapmaker Orca Full(er) Spectrum.

# Features

## Mixed-Color Filaments
Snapmaker Orca Full(er) Spectrum includes support for **virtual mixed-color filaments** designed for the Snapmaker U1 multi-color printer with independent print heads.

### How It Works
- **Create new color appearances**: Combine two physical filaments so nearby printed lines or shells create the visual impression of a blended color
- **Shell Blend mode**: Use one filament on the outside wall and the second filament on the next inner wall
- **Top/bottom surface blending**: Split visible top and bottom solid surface paths between both colors so flat faces do not collapse back to one physical filament
- **Example**: Blue outside + yellow inside can lean green-ish; red + white can lean pink-ish; yellow + red can lean orange-ish
- **Customizable ratios**: Existing mixed-filament modes can still use alternation patterns, while Shell Blend focuses on fixed outer/inner shell placement

### Shell Blend: Outer vs Inner
The **Add Shell Blend** button creates entries labeled like `Outer F1 / Inner F2`.

- **Outer F#** is the physical filament printed on the visible outside wall
- **Inner F#** is the physical filament printed on the next shell behind that outside wall
- Both directions are created because `Outer F1 / Inner F2` can look different from `Outer F2 / Inner F1`
- The outside color usually dominates the shade, while the inner color influences the final appearance depending on filament opacity, wall thickness, lighting, and line width

This is not limited to red and blue. The slicer can generate shell-blend entries for any two loaded filament colors.

### Features
- Automatic generation of all possible color combinations from your loaded filaments
- New **Add Shell Blend** button for fixed outer-wall / inner-wall two-color blends
- Visual preview showing the additive color blend
- Enable/disable individual mixed filaments
- Per-layer resolution control with customizable ratios
- Optional per-pair Bias control for slightly recessing one component to push the apparent color toward the other
- Seamless integration with the existing filament management system

### Using Mixed Filaments
1. Load 2 or more physical filaments in your printer
2. The "Mixed Colors" panel will automatically appear in the sidebar
3. Click **Add Shell Blend** to generate outer/inner shell blend entries for every two-filament pair
4. Each combination shows:
   - Color preview swatch
   - Component filaments or shell relationship, such as `Outer F1 / Inner F2`
   - Layer ratio or pattern controls where applicable
   - Enable/disable checkbox
5. Mixed filaments can be assigned to objects just like physical filaments
6. During slicing, Shell Blend entries keep the outside wall and next inner wall tied to their chosen physical filaments

### Bias Control
Snapmaker Orca Full(er) Spectrum also includes an optional **Bias** control for mixed filament pairs. When enabled in **Print Settings -> Others -> Mixed Filaments**, each mixed row gets a compact inline Bias value:

- **Positive Bias** recesses the second filament in the pair
- **Negative Bias** recesses the first filament in the pair
- This lets you shift the apparent color without changing the nominal layer cadence
- The inline preview updates to show the estimated apparent mix shift

Example: for a pair like `F1 + F2`, a positive bias makes `F2` sit slightly lower, so `F1` visually dominates more. A negative bias does the opposite and recesses `F1`.

### Dithering Settings
Snapmaker Orca Full(er) Spectrum includes advanced dithering controls to fine-tune the layer alternation behavior for mixed filaments. These settings are found in **Others → Dithering** in the print settings:

#### Dithering Cadence Height A & B
- **What it does**: Controls the height (in mm) of each alternating segment for the two component filaments
- **Cadence Height A**: The height of layers using the first filament in the mix
- **Cadence Height B**: The height of layers using the second filament in the mix
- **Example**: Setting A=0.3mm and B=0.15mm creates a 2:1 ratio pattern where you get twice as much of filament A as filament B
- **Use case**: Fine-tune color intensity by adjusting the relative amounts of each component color

#### Dithering Step Size
- **What it does**: Defines the Z-height increment (in mm) for each dithering step
- **Purpose**: Controls the resolution of the layer alternation pattern
- **Default**: Typically matches your layer height setting
- **Advanced usage**: Set smaller values for smoother color transitions, or larger values for more distinct color banding
- **Compatibility**: Must be compatible with your printer's Z-axis resolution

These settings give you precise control over how your mixed colors appear in the final print, allowing you to achieve different visual effects from the same filament combinations.

### Technical Details
- Virtual filament IDs start after physical filaments (e.g., with 4 physical filaments, first mixed ID is 5)
- Layer-based alternation is computed during tool ordering
- Shell Blend entries use fixed grouped shell patterns to keep outer and inner components stable across layers
- Visible top and bottom solid surfaces can be split into adjacent paths for both component filaments
- Works with all existing features: supports, infill, and multi-material painting

# How to install
**Windows**: 
1.  Download the installer for your preferred version from the [releases page](https://github.com/tjamz/OrcaSlicer-FullerSpectrum-test/releases).
    - *For convenience there is also a portable build available.*
    - *If you have troubles to run the build, you might need to install following runtimes:*
      - [MicrosoftEdgeWebView2RuntimeInstallerX64](https://github.com/SoftFever/OrcaSlicer/releases/download/v1.0.10-sf2/MicrosoftEdgeWebView2RuntimeInstallerX64.exe)
          - [Details of this runtime](https://aka.ms/webview2)
          - [Alternative Download Link Hosted by Microsoft](https://go.microsoft.com/fwlink/p/?LinkId=2124703)
      - [vcredist2019_x64](https://github.com/SoftFever/OrcaSlicer/releases/download/v1.0.10-sf2/vcredist2019_x64.exe)
          -  [Alternative Download Link Hosted by Microsoft](https://aka.ms/vs/17/release/vc_redist.x64.exe)
          -  This file may already be available on your computer if you've installed visual studio.  Check the following location: `%VCINSTALLDIR%Redist\MSVC\v142`

**Mac**:
1. Download the DMG for your computer: `arm64` version for Apple Silicon and `x86_64` for Intel CPU.  
2. Drag Snapmaker_Orca.app to Application folder. 
3. *If you want to run a build from a PR, you also need to follow the instructions below:*  
    <details quarantine>
    - Option 1 (You only need to do this once. After that the app can be opened normally.):
      - Step 1: Hold _cmd_ and right click the app, from the context menu choose **Open**.
      - Step 2: A warning window will pop up, click _Open_  
      
    - Option 2:  
      Execute this command in terminal: `xattr -dr com.apple.quarantine /Applications/Snapmaker_Orca.app`
      ```console
          softfever@mac:~$ xattr -dr com.apple.quarantine /Applications/Snapmaker_Orca.app
      ```
    - Option 3:  
        - Step 1: open the app, a warning window will pop up  
            ![image](./SoftFever_doc/mac_cant_open.png)  
        - Step 2: in `System Settings` -> `Privacy & Security`, click `Open Anyway`:  
            ![image](./SoftFever_doc/mac_security_setting.png)  
    </details>
    
**Linux (Ubuntu)**:
 1. If you run into trouble executing it, try this command in the terminal:  
    `chmod +x /path_to_appimage/Snapmaker_Orca_Linux.AppImage`
    
# How to compile
- Windows 64-bit  
  - Tools needed: Visual Studio 2019, Cmake, git, git-lfs, Strawberry Perl.
      - You will require cmake version 3.14 or later, which is available [on their website](https://cmake.org/download/).
      - Strawberry Perl is [available on their GitHub repository](https://github.com/StrawberryPerl/Perl-Dist-Strawberry/releases/).
  - Run `build_release.bat` in `x64 Native Tools Command Prompt for VS 2019`
  - Note: Don't forget to run `git lfs pull` after cloning the repository to download tools on Windows

- Mac 64-bit  
  - Tools needed: Xcode, Cmake, git, gettext, libtool, automake, autoconf, texinfo
      - You can install most of them by running `brew install cmake gettext libtool automake autoconf texinfo`
  - run `build_release_macos.sh`
  - To build and debug in Xcode:
      - run `Xcode.app`
      - open ``build_`arch`/Snapmaker_Orca.Xcodeproj``
      - menu bar: Product => Scheme => Snapmaker_Orca
      - menu bar: Product => Scheme => Edit Scheme...
          - Run => Info tab => Build Configuration: `RelWithDebInfo`
          - Run => Options tab => Document Versions: uncheck `Allow debugging when browsing versions`
      - menu bar: Product => Run

- Ubuntu 
  - Dependencies **Will be auto-installed with the shell script**: `libmspack-dev libgstreamerd-3-dev libsecret-1-dev libwebkit2gtk-4.0-dev libosmesa6-dev libssl-dev libcurl4-openssl-dev eglexternalplatform-dev libudev-dev libdbus-1-dev extra-cmake-modules libgtk2.0-dev libglew-dev libudev-dev libdbus-1-dev cmake git texinfo`
  - run 'sudo ./BuildLinux.sh -u'
  - run './BuildLinux.sh -dsir'


# Note: 
If you're running Klipper, it's recommended to add the following configuration to your `printer.cfg` file.
```
# Enable object exclusion
[exclude_object]

# Enable arcs support
[gcode_arcs]
resolution: 0.1
```


## Some background
**Snapmaker Orca Full(er) Spectrum** is forked from Snapmaker Orca, which is originally forked from Orca Slicer by SoftFever.

Orca Slicer was originally forked from Bambu Studio, it was previously known as BambuStudio-SoftFever.
Bambu Studio is forked from [PrusaSlicer](https://github.com/prusa3d/PrusaSlicer) by Prusa Research, which is from [Slic3r](https://github.com/Slic3r/Slic3r) by Alessandro Ranellucci and the RepRap community. 
Orca Slicer incorporates a lot of features from SuperSlicer by @supermerill
Orca Slicer's logo is designed by community member Justin Levine(@freejstnalxndr)

## Acknowledgements
Special thanks to [u/Aceman11100](https://www.reddit.com/user/Aceman11100/) for the inspiration and idea behind the mixed-color filament feature!  


# License
Snapmaker Orca Full(er) Spectrum is licensed under the GNU Affero General Public License, version 3. Snapmaker Orca Full(er) Spectrum is based on Snapmaker Orca.

Snapmaker Orca is licensed under the GNU Affero General Public License, version 3. Snapmaker Orca is based on Orca Slicer by SoftFever.

Orca Slicer is licensed under the GNU Affero General Public License, version 3. Orca Slicer is based on Bambu Studio by BambuLab.

Bambu Studio is licensed under the GNU Affero General Public License, version 3. Bambu Studio is based on PrusaSlicer by PrusaResearch.

PrusaSlicer is licensed under the GNU Affero General Public License, version 3. PrusaSlicer is owned by Prusa Research. PrusaSlicer is originally based on Slic3r by Alessandro Ranellucci.

Slic3r is licensed under the GNU Affero General Public License, version 3. Slic3r was created by Alessandro Ranellucci with the help of many other contributors.

The GNU Affero General Public License, version 3 ensures that if you use any part of this software in any way (even behind a web server), your software must be released under the same license.

Orca Slicer includes a pressure advance calibration pattern test adapted from Andrew Ellis' generator, which is licensed under GNU General Public License, version 3. Ellis' generator is itself adapted from a generator developed by Sineos for Marlin, which is licensed under GNU General Public License, version 3.

The Bambu networking plugin is based on non-free libraries from BambuLab. It is optional to the Orca Slicer and provides extended functionalities for Bambulab printer users.

Filament color blending is powered by [FilamentMixer](https://github.com/justinh-rahb/filament-mixer), an openly licensed library.

# Feedback & Contribution
We greatly value feedback and contributions from our users. Your feedback will help us to further develop Snapmaker Orca Full(er) Spectrum for our community.
- To submit a bug or feature request, file an issue in GitHub Issues.
- To contribute some code, make sure you have read and followed our guidelines for contributing.
