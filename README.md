# FMacros

A collection of practical Swift Macros for iOS/macOS development.

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%20%7C%20macOS%2013-blue.svg)](https://developer.apple.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Macros

### `#hexColor` — Hex Color Property Generator

Generates `UIColor` class properties with auto-generated doc comments from hex strings. Write the hex value once — the macro produces both the documentation and the implementation.

```swift
extension UIColor {
    #hexColor("red9", "#4D000A")
    #hexColor("brand6_normal", "#FFDD4C", desc: "Brand primary")
    #hexColor("gray2_A7", "#333333", alpha: 0.7)
    #hexColor("gray2_A7", "#333333", alpha: 0.7, desc: "Gray 70%")
}
```

Expands to:

```swift
extension UIColor {
    /// `#4D000A`
    class var red9: UIColor { return UIColor(hexString: "#4D000A") ?? .clear }

    /// Brand primary (`#FFDD4C`)
    class var brand6_normal: UIColor { return UIColor(hexString: "#FFDD4C") ?? .clear }

    /// `#333333` alpha: 0.7
    class var gray2_A7: UIColor { return UIColor(hexString: "#333333", alpha: 0.7) ?? .clear }

    /// Gray 70% (`#333333` alpha: 0.7)
    class var gray2_A7: UIColor { return UIColor(hexString: "#333333", alpha: 0.7) ?? .clear }
}
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | — | Property name |
| `hex` | `String` | — | Hex color value (`#RGB` or `#RRGGBB`) |
| `alpha` | `Float` | `1.0` | Opacity (omitted from output when `1.0`) |
| `desc` | `String` | `""` | Optional semantic description |

> **Note:** This macro generates code that calls `UIColor(hexString:)` / `UIColor(hexString:alpha:)`. You need to provide this initializer in your project (e.g. via an extension on `UIColor`).

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jeffy-w/FMacros.git", from: "1.0.0"),
]
```

Then add `"FMacros"` to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["FMacros"]
),
```

Or in Xcode: **File → Add Package Dependencies…** → paste the repository URL.

## Requirements

- Swift 6.0+
- iOS 15+ / macOS 13+

## License

MIT — see [LICENSE](LICENSE) for details.
