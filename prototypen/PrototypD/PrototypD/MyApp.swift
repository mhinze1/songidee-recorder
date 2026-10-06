import SwiftUI

@main struct MyApp: App {
    /// Das App-Objekt entsteht nur einmal pro Kaltstart.
    /// Zurückwechseln aus dem Hintergrund zählt daher nicht.
    private let startResult = StartLogStore.recordColdStart()

    var body: some Scene {
        WindowGroup {
            ContentView(result: startResult)
        }
    }
}
