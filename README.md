# TrainerWatch
Student: Ramone Hayes 
Class: MDI1 112: Mobile Applications for Wearables – Introductory -- CH4

Trainer Watch is a  health tracking app built for Apple Watch. TrainerWatch helps you log daily calorie intake, water consumption, and monitor your heart rate — all from your wrist with minimal interaction.

---

## Features

- **Calorie Tracking** — Log meals and snacks with quick-add presets (100, 200, 300, 500, 1000 kcal) or fine-tune with a ±50 stepper
- **Water Tracking** — Log water intake with quick-add presets (100, 250, 500, 750, 1000 ml)
- **Progress Rings** — Visual circular progress indicators for daily calorie and water goals
- **Personalised Goals** — Set your own daily calorie and water targets with preset options
- **Motivational Quotes** — A quote overlay appears after each logged entry, fetched from the ZenQuotes API with offline fallbacks
- **Haptic Feedback** — Tactile confirmation for every interaction, with special haptics for goal achievements
- **Offline-First** — All data persisted locally via UserDefaults; quote fallbacks ensure the app works without connectivity

---

## Project Structure

```
TrainerWatch/
├── App
│   ├── TrainerWatch_Watch_AppApp.swift   # App entry point
│   └── ContentView.swift                 # Root NavigationStack
│
├── Models
│   ├── DiaryEntry.swift                  # Calorie/water log entry model
│   ├── EntryType.swift                   # Enum: .calories / .water
│   ├── MotivationalQuote.swift           # Quote model + ZenQuotes API response wrapper
│   └── UserGoals.swift                   # Daily goals model with defaults
│
├── ViewModels
│   └── HealthViewModel.swift             # Main @MainActor ObservableObject, single source of truth
│
├── Services
│   ├── HealthKitManager.swift            # HealthKit heart rate read access
│   ├── MotivationalQuoteService.swift    # ZenQuotes API fetch with offline fallback
│   └── StorageManager.swift             # UserDefaults persistence for entries and goals
│
├── Managers
│   └── HapticManager.swift              # WKInterfaceDevice haptic feedback wrapper
│
└── Views
    ├── MainDashboardView.swift           # Today's progress rings + quick-add buttons
    ├── AddEntryView.swift                # Quick-add + stepper for calories or water
    ├── GoalsSettingsView.swift           # Daily goal configuration
    ├── ProgressRingView.swift            # Reusable circular progress ring component
    ├── QuickAddButton.swift              # Reusable quick-add button component
    └── QuoteOverlayView.swift            # Motivational quote overlay shown after logging
```

---

## Architecture

TrainerWatch follows **MVVM** (Model-View-ViewModel):

- **Models** are simple `Codable` structs with no business logic
- **HealthViewModel** is the single `@ObservedObject` passed through the view hierarchy — views never talk to services directly
- **Services and Managers** are singletons accessed only by the ViewModel
- **Views** are stateless where possible, deriving all display values from the ViewModel

---

## Data Persistence

All diary entries and user goals are stored in `UserDefaults` via `StorageManager`. The storage layer:

- Encodes/decodes using `JSONEncoder` / `JSONDecoder`
- Filters entries to today's date for daily totals
- Falls back to `UserGoals.defaultGoals` (2000 kcal / 2000 ml) if no goals are saved

---

## HealthKit

The app requests **read-only** access to heart rate data (`HKQuantityType` `.heartRate`). No health data is written back to HealthKit.

Authorization is requested at runtime via `HealthKitManager.requestAuthorization()`. The app degrades gracefully if permission is denied — the heart rate screen will simply show no data.

---

## Motivational Quotes

Quotes are fetched from the [ZenQuotes API](https://zenquotes.io) (`https://zenquotes.io/api/random`) — free, no API key required.

- A quote is pre-fetched silently on app launch and cached
- After each diary entry, the cached quote is shown instantly while a new one is fetched in the background
- If the network is unavailable, one of 8 built-in fallback quotes is shown

---

## Design Principles

The app was built around the constraints of Apple Watch:

| Principle | Implementation |
|---|---|
| **Glanceability** | Progress rings and totals visible instantly on the dashboard |
| **Minimal interaction** | Quick-add presets require a single tap |
| **Limited functionality** | Only two tracked metrics — calories and water |
| **Offline-first** | Local storage + fallback quotes ensure full functionality without network |
| **Haptic confirmation** | Every action confirmed via haptics, no need to look at screen |

---

## Requirements

- watchOS 10.0+
- Xcode 15+
- Apple Watch (Series 4 or later recommended for heart rate)
- HealthKit entitlement enabled in project capabilities

---

## Setup

1. Clone the repository
2. Open `TrainerWatch.xcodeproj` in Xcode
3. Select your Apple Watch target
4. Enable **HealthKit** in *Signing & Capabilities*
5. Build and run on a physical Apple Watch or simulator

## Future Improvments
1. Heart Rate monitor that displays current BPM
2. Implement strategies to manage sensor data efficiently.
3. Optimize the app to reduce battery consumption, especially while using sensors (heart rate, motion tracking).
