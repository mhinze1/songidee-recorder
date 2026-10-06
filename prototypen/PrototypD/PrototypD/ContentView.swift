import SwiftUI

struct ContentView: View {
    let result: StartLogResult

    var body: some View {
        NavigationStack {
            List {
                switch result {
                case .recorded(let log):
                    Section {
                        LabeledContent("Kaltstarts", value: "\(log.starts.count)")
                        if let first = log.starts.first {
                            LabeledContent("Erster Start", value: format(first))
                        }
                        if let last = log.starts.last {
                            LabeledContent("Dieser Start", value: format(last))
                        }
                    }
                    Section("Alle Starts, neueste zuerst") {
                        ForEach(Array(log.starts.enumerated().reversed()), id: \.offset) { index, date in
                            LabeledContent("Nr. \(index + 1)", value: format(date))
                        }
                    }
                case .failed(let message):
                    Section("Fehler") {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }

                Section("App") {
                    LabeledContent("Bundle-ID", value: Bundle.main.bundleIdentifier ?? "unbekannt")
                    LabeledContent("Version", value: appVersion)
                }
            }
            .navigationTitle("Prototyp D")
        }
    }

    private var appVersion: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }

    private func format(_ date: Date) -> String {
        date.formatted(date: .numeric, time: .standard)
    }
}

#Preview {
    ContentView(result: .recorded(StartLog(starts: [
        .now.addingTimeInterval(-86_400 * 3),
        .now.addingTimeInterval(-86_400),
        .now,
    ])))
}
