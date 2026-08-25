# Bezel

A realistic SwiftUI device frame library that lets you wrap any SwiftUI view inside a beautifully rendered device bezel.

Bezel is designed to be simple:

```swift
import BezelKit

struct ContentView: View {
    var body: some View {
        Bezel {
            DemoView()
        }
    }
}
```

---

## Features 

- SwiftUI-native
- Rounded display clipping
- Realistic device bezels (Coming Soon)
- Dynamic Island support (Comming Soon, only Notch is available)
- iPhone support (Coming Soon)
- iPad support
- Lightweight
- No external dependencies
- Easy integration with Swift Package Manager

---

## Basic Usage

```swift
import BezelKit

struct ContentView: View {
    var body: some View {
        Bezel {
         Text("Hello, Bezel!")
        }
    }
}
```

---

## Example

```swift
import SwiftUI
import BezelKit

struct DemoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "iphone")
                .font(.largeTitle)

            Text("Welcome to Bezel")
                .font(.title.bold())

            Text("Render your app inside a realistic device frame.")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ContentView: View {
    var body: some View {
        Bezel {
            DemoView()
        }
    }
}
```

---

## Why Bezel?

Most preview libraries only draw a rounded rectangle around your content.

Bezel focuses on creating a realistic device presentation experience while keeping the API extremely simple:

```swift
Bezel {
    YourView()
}
```

No complex configuration is required.

---

## Requirements

- iOS 17.0+
- Swift 5.9+
- Xcode 15+ or Swift Playgrounds

---

## Roadmap

Planned features include:

- Additional iPhone models
- Additional iPad models
- Dynamic Island variations
- Hardware button customization
- Device profile system
- Landscape and portrait modes
- Enhanced hardware rendering
- Accessibility improvements

---

## Contributing

Contributions, bug reports, feature requests, and suggestions are welcome.

If you discover an issue or have an idea for improvement, please open an issue on GitHub.

---

## License

Copyright © 2026 OneCloud Developers.

All Rights Reserved.
