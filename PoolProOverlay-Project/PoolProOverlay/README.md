# PoolProOverlay — iOS table-analysis prototype

This project is a **standalone iPhone app** for manually positioning two balls and visualizing idealized 2D aim geometry. It is not an injected tweak, does not read another app's screen, and does not interact with 8 Ball Pool.

## Target device
- iPhone XS Max
- iOS 18.1.1
- Deployment target: iOS 16.0

## Build from a Windows PC
Windows cannot run Xcode or compile/sign native iOS apps locally. Use GitHub Actions with a macOS runner:
1. Create a GitHub repository and upload this folder's contents.
2. Open **Actions** and run **Build iOS app (unsigned)**.
3. Download the `PoolProOverlay-unsigned-app` artifact.
4. The artifact is an unsigned `.app` bundle, not an installable IPA.
5. To install on the iPhone, sign it with your own Apple developer credentials using a trusted signing workflow or Xcode on a Mac.

## Local build on macOS
Open `PoolProOverlay.xcodeproj` in Xcode, select an iPhone simulator or your connected iPhone, then Build.
For a device install, choose your own Team under Signing & Capabilities.

## Current features
- Draggable cue and object ball markers
- Extended geometric aim ray
- Idealized object-ball direction indicator
- Contact-point marker
- Table grid and adjustable ball diameter

## Limitations
- Manual ball placement only; no automatic camera/screen recognition.
- No spin, speed, cloth, cushion deformation, pocketing, or full collision simulation.
- Geometry is an approximation and cannot guarantee 100% real-shot accuracy.
- This app deliberately does not inject into or modify third-party games.

## Project generation
The `.xcodeproj` is included. Open it with Xcode 15 or newer.
