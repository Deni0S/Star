# ⭐ Star

[![Type](https://img.shields.io/badge/type-assignment-blueviolet)](#)
[![iOS](https://img.shields.io/badge/iOS-16%2B-black?logo=apple&logoColor=white)](#)
[![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?logo=swift&logoColor=white)](#)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-1575F9?logo=xcode&logoColor=white)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Year](https://img.shields.io/badge/year-2025-lightgrey)](#)

A test assignment built with **SwiftUI**, featuring dark and light theme support, transition animations, localization, and seamless authentication via **silent push**.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Readme/DarkEn.gif">
  <source media="(prefers-color-scheme: light)" srcset="Readme/LightEn.gif">
  <img alt="Region En" src="Readme/LightEn.gif" width="300">
</picture>
&nbsp;&nbsp;&nbsp;
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Readme/DarkRu.gif">
  <source media="(prefers-color-scheme: light)" srcset="Readme/LightRu.gif">
  <img alt="Region Ru" src="Readme/LightRu.gif" width="300">
</picture>

## ⚙️ Requirements

- Build a phone number input form with automatic `+7` prefix insertion
- Star movement animation when transitioning to the next screen
- Error display when an incorrect code is entered
- Dark mode support

## 🛠 Technologies

- **SwiftUI** — declarative UI framework; the entire app interface is built on it
- **Swift** — the development language, leveraging modern language features
- **MVVM** — separation of UI and business logic: the View renders state, while the ViewModel (ObservableObject) handles logic and exposes ready-to-use data via @Published
- **Matched Geometry Effect** — smooth transitions between screens while preserving element geometry
- **Silent Push** — silent delivery of an SMS code to the app without user confirmation
- **Localization** — multi-language support via the Localizable.xcstrings string catalog
- **Logging** — centralized logging for debugging network requests and screen lifecycles
- **Combine** — reactive streams: countdown timers, event handling, and binding @Published properties to the UI
- **async / await** — all network requests use structured concurrency: Task, TaskGroup, cancellation when leaving a screen
- **Tinted Icon** — an icon with tint color support: correctly recolors to match the theme and system accent color
- **Dark Mode** — light and dark theme support: colors are defined via assets with Any/Dark Appearance, and the UI rebuilds automatically

## 📦 Installation

```bash
git clone https://github.com/your-org/star-project.git
cd star-project
open StarProject.xcodeproj
```
