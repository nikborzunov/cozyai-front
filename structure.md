# Project Structure

cozyai-front
├── __tests__
│   └── App.test.tsx
├── assets
├── ios
│   ├── Bridge
│   │   ├── RoomScanViewManager.m
│   │   └── RoomScanViewManager.swift
│   ├── CozyAI
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   ├── LaunchScreen.storyboard
│   │   └── PrivacyInfo.xcprivacy
│   ├── Modules
│   │   └── ARScan
│   │       ├── Processing
│   │       │   ├── MeshDataConverter.swift
│   │       │   └── MeshDataStreamer.swift
│   │       ├── Rendering
│   │       │   ├── SurfaceHighlighter.swift
│   │       │   └── SurfaceVisualizer.swift
│   │       ├── ARSessionManager.swift
│   │       └── RoomScanView.swift
│   ├── .DS_Store
│   ├── .xcode.env
│   ├── .xcode.env.local
│   ├── Podfile
│   ├── Podfile.lock
│   └── RCTBridgeModule.swift
├── src
│   ├── components
│   │   ├── Description.tsx
│   │   ├── ExitButton.tsx
│   │   ├── Header.tsx
│   │   ├── ScanButton.tsx
│   │   └── StatusMessage.tsx
│   ├── RoomScanner
│   │   ├── RoomScannerContainer.tsx
│   │   └── RoomScannerView.tsx
│   └── App.tsx
├── .DS_Store
├── .eslintrc.js
├── .gitignore
├── .prettierrc.js
├── .structureignore
├── .watchmanconfig
├── app.json
├── babel.config.js
├── Gemfile
├── Gemfile.lock
├── index.js
├── jest.config.js
├── metro.config.js
├── package-lock.json
├── package.json
├── react-native.config.js
├── README.md
├── structure.md
└── tsconfig.json
