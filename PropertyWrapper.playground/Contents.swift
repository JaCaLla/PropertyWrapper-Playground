import UIKit

@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    let range: ClosedRange<Value>

    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = range.contains(wrappedValue) ? wrappedValue : range.lowerBound
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}

// Uso del Property Wrapper
struct Player {
    @Clamped(wrappedValue: 50, 0...100) var health: Int
}

var player = Player()
player.health = 120
print(player.health) // Output: 100 (se ajusta al máximo del rango)


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@MainActor
struct Settings {
    @UserDefault(key: "username", defaultValue: "Guest")
    static var username: String
}

Settings.username = "SwiftUser"
print(Settings.username) // Output: "SwiftUser"
