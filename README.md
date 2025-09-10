# WordPathSpeak

**WordPathSpeak** is a SwiftUI-based iOS app that allows users to create and manage custom vocabulary items with speech playback, image support, and categorization. Built for modularity, accessibility, and future expansion into speech and remote ID domains.

## 🚀 Features

- Add custom words with label, category, image, and audio
- Choose between synthesized speech or recorded playback
- Save and manage word items locally
- Modular architecture for easy extension
- SwiftUI navigation and form-based input
- Designed for educational, accessibility, and speech-driven use cases

## 🧱 Architecture

- `Models/WordItem.swift`: Defines the core data structure with Codable and Identifiable support
- `Services/DataStore.swift`: ObservableObject for managing word items and profile context
- `Views/AddWordView.swift`: Form-based UI for creating new words
- `App/WordPathSpeakApp.swift`: Entry point with environment injection

## 📦 Requirements

- iOS 16.0+
- Xcode 15+
- Swift 5.9+

## 🛠️ Installation

Clone the repo and open in Xcode:

```bash
git clone https://github.com/RemoteIPTLLC/WordPathSpeak.git
cd WordPathSpeak
open WordPathSpeak.xcodeproj
