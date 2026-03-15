# Baraholka

A second-hand marketplace iOS app built with Swift and SwiftUI.

## Overview

Baraholka (Russian: "барахолка", meaning flea market) is a native iOS application that lets users buy and sell second-hand items. The app is built entirely with SwiftUI and follows modern Swift concurrency patterns.

## Features

- **Home Feed** — Featured and recently-added listings at a glance
- **Browse & Search** — Filter by category, condition, price range, and sort order
- **Item Detail** — Full-screen listing view with seller info, description, and contact action
- **Create Listing** — Post a new item for sale with photos, category, condition, and price
- **Messages** — In-app messaging between buyers and sellers
- **Profile** — User profile with rating, reviews, and active listings

## Project Structure

```
Sources/
├── BaraholkaCore/          # Cross-platform models & services (testable on Linux)
│   ├── Models/
│   │   ├── Item.swift      # Marketplace listing model
│   │   ├── User.swift      # User/seller model
│   │   ├── Category.swift  # Item category model
│   │   └── Message.swift   # Message & conversation models
│   └── Services/
│       └── MockDataService.swift  # In-memory sample data & search
└── Baraholka/              # iOS app target (SwiftUI)
    ├── App/
    │   ├── BaraholkaApp.swift
    │   └── ContentView.swift
    ├── Views/
    │   ├── HomeView.swift
    │   ├── SearchView.swift
    │   ├── ItemDetailView.swift
    │   ├── CreateListingView.swift
    │   ├── MessagesView.swift
    │   ├── ProfileView.swift
    │   └── Components/
    │       ├── ItemCardView.swift
    │       └── CategoryFilterView.swift
    └── ViewModels/
        ├── HomeViewModel.swift
        ├── SearchViewModel.swift
        ├── ItemDetailViewModel.swift
        └── CreateListingViewModel.swift
Tests/
└── BaraholkaCoreTests/     # Unit tests for models and services
```

## Requirements

- Xcode 15+
- iOS 17+
- Swift 5.9+

## Building & Testing

Open the project in Xcode or use Swift Package Manager:

```bash
# Run unit tests (cross-platform, works on Linux too)
swift test

# Build the core library
swift build
```

## Architecture

The project uses a layered architecture:

- **Models** — Plain `Sendable` value types (`struct`) for data
- **Services** — `MockDataService` as a simple in-memory data layer (replace with a real API client)
- **ViewModels** — `@Observable` classes driving each screen
- **Views** — SwiftUI views composed from reusable components
