# Prototyp-Plan für Claude Code: Songidee Recorder

Dieser Plan beschreibt vier kleine Test-Apps, die vor Version 1 klären, ob die kritischen Funktionen auf dem iPhone des Nutzers funktionieren.

## Kontext und Regeln

- Der Nutzer programmiert nicht. Erkläre jeden Schritt in einfachen Worten und nenne die genauen Klicks in Xcode und am iPhone.
- Zielgerät: iPhone 15 Pro Max. Mindestversion iOS 18, SwiftUI, kostenloser Apple Account (Personal Team), kein iCloud, keine Push-Nachrichten. Installation per Xcode.
- Arbeite in kleinen Schritten. Baue nach jedem Schritt und melde Fehler zuerst in einfachen Worten, bevor du sie behebst.
- Git von Anfang an, regelmäßige Commits.
- Baue nur, was in diesem Plan oder im Pflichtenheft steht. Bei Lücken fragst du nach, statt zu raten.
- Jeder Prototyp ist eine eigene, minimale App in einem eigenen Ordner. Code wird nicht blind in Version 1 übernommen.
- Zu jedem Prototyp gibt es einen Ergebnisbericht: bestanden, teilweise oder nicht bestanden, mit Beobachtungen.
- Aussagen aus Entwicklerforen unten sind ungeprüft. Lies die aktuelle offizielle Apple-Dokumentation und prüfe sie am Gerät, bevor du etwas als gegeben behandelst.

## Vorbereitung (einmalig)

1. In Xcode ein neues Projekt anlegen (iOS, App, SwiftUI) und als Team das Personal Team wählen.
2. Am iPhone den Entwicklermodus einschalten und dem Entwickler vertrauen. Testlauf der leeren App am Gerät.
3. Ein Git-Repository mit einem Unterordner pro Prototyp anlegen.
4. Mikrofon-Berechtigung mit deutschem Erklärungstext einrichten.

## Prototyp A: Aufnahmestart ohne geöffnete App

**Frage:** Lässt sich eine Aufnahme aus Action Button oder Sperrbildschirm starten, und wie schnell startet sie nach dem Öffnen der App?

**Bauen:** Eine minimale App mit großem Aufnahme-Button und ein App Intent "Aufnahme starten", den der Nutzer dem Action Button oder einem Kurzbefehl zuweist.

**Ungeprüfter Hinweis aus Entwicklerforen:** Eine Aufnahme aus dem Hintergrund startet offenbar nur, wenn die App schon aktiv ist. Unter iOS 26 wird von Fehlern bei der Audio-Session auf dem Sperrbildschirm berichtet. Prüfe das und rate nicht.

**Tests am iPhone:**

1. App im Vordergrund: Zeit vom Öffnen bis Aufnahmebeginn messen.
2. App im Hintergrund: Action Button drücken.
3. Sperrbildschirm: Action Button drücken.
4. Nach App-Neustart: Action Button drücken.

**Bestanden, wenn:** Mindestens Variante 1 klappt in maximal 2 Sekunden. Gut ist, wenn Variante 2 oder 3 ohne Entsperren funktioniert. Notiere genau, was klappt.

## Prototyp B: Aufnahme-Grundlage und Vorlauf-Puffer

**B1: Absturzsichere Aufnahme.** Dieser Teil ist keine Vorgabe des Nutzers, sondern Voraussetzung für Version 1.

- Aufnahme über AVAudioEngine als unkomprimierte Zwischendatei (CAF) auf die Platte.
- Nach dem Stopp Umwandlung in m4a.
- Beim nächsten Start unfertige Zwischendateien suchen und retten.

Tests: App während der Aufnahme im App-Umschalter wegwischen, danach neu starten. Außerdem ein Anruf während der Aufnahme. **Bestanden, wenn** die bisherige Aufnahme abspielbar gerettet wird.

**B2: Vorlauf-Puffer.** Die App hält die letzten 20 bis 30 Sekunden im Arbeitsspeicher und hängt sie vor die Aufnahme.

Tests: Puffer 30 Minuten im Vordergrund laufen lassen, danach im Hintergrund mit ausgeschaltetem Bildschirm. Notiere, ob iOS die App beendet, wie viel Akku verbraucht wird und ob der orange Mikrofon-Punkt sichtbar bleibt.

**Bestanden, wenn** der Puffer mindestens 30 Minuten ohne Beenden durch iOS läuft und der Akkuverbrauch für den Nutzer akzeptabel ist. Sonst bleibt der Puffer außerhalb von Version 1.

## Prototyp C: USB-Audio-Interface

**Frage:** Lässt sich ein USB-Audio-Interface oder USB-Mikrofon als Eingang wählen und fehlerfrei aufnehmen?

**Bauen:** Eine Liste der verfügbaren Eingänge, Auswahl eines Eingangs, 10 Sekunden aufnehmen, abspielen.

**Tests am iPhone:**

1. Ohne Interface: iPhone-Mikrofon.
2. Mit Interface: Hersteller und Modell notieren, Eingang wählen, aufnehmen.
3. Stecker während der Aufnahme ziehen: Die App muss sauber stoppen und speichern.

**Bestanden, wenn** der Eingang wählbar ist, die Aufnahme sauber klingt und das Abziehen die Aufnahme nicht zerstört.

## Prototyp D: AltStore-Erneuerung über 14 Tage

**Frage:** Kann eine selbst gebaute App 14 Tage laufen, einschließlich zwei automatischer Erneuerungen, ohne Datenverlust?

**Bauen:** Eine leere App, die bei jedem Start Datum und einen Zähler in eine Datei schreibt und anzeigt. So sieht der Nutzer, ob die Daten erhalten bleiben.

**Vorgehen:**

- Installation zuerst per Xcode.
- Claude Code liest die aktuelle AltStore-Dokumentation und erklärt dem Nutzer die Einrichtung. Offen ist, wie die App aus Xcode für AltStore bereitgestellt wird und ob das mit dem kostenlosen Account funktioniert.
- Der Mac muss in der Erneuerungswoche im selben WLAN erreichbar sein. AltStore braucht dafür die Apple-ID-Zugangsdaten des Nutzers.

**Bestanden, wenn** die App nach 14 Tagen noch läuft und der Zähler nicht zurückgesetzt wurde.

## Reihenfolge

1. Prototyp D zuerst und sofort, er läuft 14 Tage im Hintergrund weiter.
2. Danach A, B und C.
3. Gemeinsame Auswertung, danach Entscheidung über den Umfang von Version 1.

## Ergebnisvorlage

| Prototyp | Ergebnis | Beobachtungen | Folge für das Pflichtenheft |
| --- | --- | --- | --- |
| A Aufnahmestart |  |  |  |
| B1 Absturzsichere Aufnahme |  |  |  |
| B2 Vorlauf-Puffer |  |  |  |
| C USB-Audio |  |  |  |
| D AltStore |  |  |  |
