# Songidee Recorder: Projektkontext für Claude Code

## Worum es geht
iOS-App (nur iPhone) als Ersatz für Sprachmemos: Songideen schnell aufnehmen, sofort einsortieren, später wiederfinden und als Datei teilen.

## Nutzer
Der Nutzer programmiert nicht. Erkläre jeden Schritt in einfachen Worten und nenne genaue Klicks in Xcode und am iPhone. Bei Fehlern erst erklären, was passiert ist, dann beheben.

## Festgelegter Rahmen
- Swift und SwiftUI, nativ. Mindestversion iOS 18. Zielgerät: iPhone 15 Pro Max.
- Kostenloser Apple Account (Personal Team): kein iCloud, keine Push-Nachrichten. Die Signatur läuft nach 7 Tagen ab, Installation per Xcode.
- Datenbank lokal (SwiftData), Audiodateien im App-Ordner. Kein Server, keine Konten.
- Aufnahme über AVAudioEngine: zuerst unkomprimiert (CAF), nach dem Stopp Umwandlung in m4a (AAC). Beim nächsten Start werden unfertige Aufnahmen gerettet.
- Export: nach jeder Aufnahme inkrementell in einen vom Nutzer gewählten Ordner, dazu ein manueller Vollexport.
- Löschen: Papierkorb mit 30 Tagen. Import von Sprachmemos über die Dateien-App, Duplikate über den Dateiinhalt erkennen.
- Zwei umschaltbare Looks (Transmitter-Stil und Dunkel) über zentrale Look-Werte. Schriften: Anton und Work Sans, Lizenz vor dem Einbau prüfen.

## Arbeitsregeln
- Kleine Schritte. Nach jedem Schritt bauen und testen.
- Baue nur, was in den Dokumenten im Ordner docs/ steht. Bei Lücken fragen, nicht raten.
- Git von Anfang an, regelmäßige Commits mit verständlichen Meldungen.
- Nichts löschen oder überschreiben, ohne dass vorher ein Export möglich war.
- Lies aktuelle Apple-Dokumentation, statt aus dem Gedächtnis zu arbeiten. Kennzeichne ungeprüfte Annahmen ausdrücklich als ungeprüft.
- Entscheidende Tests (Mikrofon, USB-Interface, Hintergrund, Action Button) macht der Nutzer am echten iPhone. Liefere dafür eine Checkliste in einfachen Schritten.

## Dokumente
- docs/Pflichtenheft.md: Funktionen, Versionen, Entscheidungen.
- docs/Prototyp-Plan.md: vier Test-Apps vor Version 1.

## Reihenfolge
Zuerst die Prototypen. Prototyp D (AltStore, läuft 14 Tage) sofort starten, danach A, B und C, danach Version 1.
