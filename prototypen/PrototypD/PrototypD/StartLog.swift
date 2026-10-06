import Foundation

/// Inhalt der Datei startprotokoll.json: alle Kaltstarts der App, ältester zuerst.
struct StartLog: Codable {
    var starts: [Date] = []
}

/// Ergebnis des Startvorgangs, das die Oberfläche anzeigt.
enum StartLogResult {
    case recorded(StartLog)
    case failed(String)
}

enum StartLogStore {
    static let fileName = "startprotokoll.json"

    /// Ordner "Application Support" im eigenen Bereich der App.
    static var fileURL: URL {
        get throws {
            let folder = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return folder.appendingPathComponent(fileName)
        }
    }

    /// Liest das Protokoll, hängt den aktuellen Start an und speichert es.
    /// Wird genau einmal pro Kaltstart aufgerufen.
    /// Ist die vorhandene Datei unlesbar, wird sie nicht überschrieben.
    static func recordColdStart(now: Date = .now) -> StartLogResult {
        do {
            let url = try fileURL
            var log = StartLog()

            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    let data = try Data(contentsOf: url)
                    log = try decoder.decode(StartLog.self, from: data)
                } catch {
                    return .failed("Die vorhandene Datei ist unlesbar und bleibt unverändert: \(error.localizedDescription)")
                }
            }

            log.starts.append(now)
            let data = try encoder.encode(log)
            try data.write(to: url, options: .atomic)
            return .recorded(log)
        } catch {
            return .failed("Speichern fehlgeschlagen: \(error.localizedDescription)")
        }
    }

    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted]
        return encoder
    }

    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
