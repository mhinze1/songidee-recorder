# Songidee Recorder – Pflichtenheft

Oct 1, 2026 · @Michael

## Ziel und Rahmen

Die App ersetzt Sprachmemos als Ort für Songideen auf dem iPhone: schnell aufnehmen, sofort einsortieren, später wiederfinden.

- **Nutzer:** ein Musiker, der selbst nicht programmiert. Claude Code in VS Code schreibt den gesamten Code.
- **Hauptschmerz:** Ideen wiederfinden und sortieren.
- **Teilen:** nur Anhören (Datei verschicken), keine Zusammenarbeit in der App.
- **Nicht-Ziele:** Android, Apple Watch, eigener Server, iCloud-Sync, gemeinsames Bearbeiten.

## Festgelegte Rahmenbedingungen

Die App läuft nur auf dem iPhone, mit kostenlosem Apple Account und ohne iCloud.

| Thema | Festlegung | Stand |
| --- | --- | --- |
| Plattform | Nur iPhone. Zum Mac per AirDrop oder Share Sheet, manuell. | Entschieden |
| Account | Kostenloser Apple Account (Personal Team), kein Developer Program. | Entschieden |
| Installation | Build per Xcode. Die Signatur läuft nach 7 Tagen ab, Erneuerung per AltStore mit Auto-Refresh. | Entschieden, ungetestet |
| Sync und Sicherung | Kein iCloud-Sync. Sicherung über iPhone-Backup und Export. | Entschieden |
| Technik | Swift und SwiftUI, nativ, Daten lokal auf dem Gerät. | Empfehlung, kein Widerspruch |
| Audioformat | AAC (m4a). | Entschieden |
| Teilen | Datei über das Share Sheet, kein Server. | Empfehlung, kein Widerspruch |

Ein kostenloser Account unterstützt weder iCloud noch Push-Benachrichtigungen. Das ist der Grund für den Verzicht auf iCloud-Sync.

## Technische Entscheidungen

Die App läuft ab iOS 18, nimmt über ein Zwischenformat auf und hält alles in einer lokalen Datenbank.

| Thema | Entscheidung |
| --- | --- |
| Mindestversion | iOS 18 oder neuer. |
| Datenhaltung | Datenbank in der App (SwiftData), Audiodateien im App-Ordner. Suche, Tags, Song-Zuordnung und Zufallsidee sind Abfragen. |
| Aufnahme | Beim Aufnehmen läuft der Ton als unkomprimierte Zwischendatei (CAF) auf die Platte, nach dem Stopp wird sie in m4a umgewandelt. Grund: Eine m4a-Datei ist nach einem Absturz unbrauchbar, weil das moov atom am Ende fehlt. Kurzzeitig 5 bis 11 MB pro Minute. |
| Aufnahmestart | Ein Tap auf den Button startet die Aufnahme. |
| Absturz-Rettung | Beim nächsten Start werden unfertige Zwischendateien gerettet. Ein Hinweis fragt, ob die Aufnahme behalten werden soll, er blockiert den Aufnahme-Button nicht. Ohne Antwort bleibt die Aufnahme in der Inbox. |
| Speicher | Warnung vor dem Start bei wenig freiem Speicher, sauberer Stopp mit Speichern, wenn es knapp wird. Grenzwerte schlägt Claude Code vor, du prüfst sie am iPhone. |
| Löschen | Gelöschte Ideen liegen 30 Tage im Papierkorb, danach endgültig gelöscht. |
| Import-Duplikate | Doppelte Dateien werden über den Inhalt erkannt und übersprungen. |
| Export | Nach jeder Aufnahme inkrementell (nur Neues und Geändertes) in einen von dir gewählten Ordner, dazu ein manueller Vollexport. Ist der Ordner ungültig, meldet die App das sichtbar. Ob ein Ordner in iCloud Drive ohne bezahlten Account funktioniert, ist ungeprüft. |
| Prüfung | Claude Code schreibt automatische Tests für die Datenlogik und eine Checkliste für Tests am echten iPhone. |
| Reihenfolge | Drei Prototypen (Aufnahmestart, Vorlauf-Puffer, USB-Audio) zuerst, der AltStore-Test läuft parallel, danach Version 1. Bis zum AltStore-Ergebnis installierst du die App alle 7 Tage per Xcode neu und exportierst vorher. |

## Datenmodell

Eine Idee ist genau eine Aufnahme. Mehrere Ideen können zu einem Song gehören, eine Idee gehört zu höchstens einem Song.

| Objekt | Felder | Regel |
| --- | --- | --- |
| Idee | Audiodatei (m4a), Zeitpunkt (automatisch), Titel (optional), Tags, Songteil (mehrfach, feste Liste), Notiz, Fertig-Häkchen, Song (optional), Herkunft (aufgenommen oder importiert) | Version 2 ergänzt BPM, Tonart (Dur oder Moll), Akkordfolge (Liste ohne Zeitbezug) und Loop-Marken (Start und Ende, das Original bleibt unverändert). |
| Song | Titel, Notiz, zugeordnete Ideen | Eine Idee hat höchstens einen Song. |
| Inbox | Keine eigene Ablage | Ansicht aller Ideen ohne Song. Mit Zuordnung verschwindet die Idee daraus. |
| Tags | Frei vergebbar | Vorschläge aus den bisher genutzten Tags. |
| Zufallsidee | Keine eigenen Daten | Wählt zufällig eine einzelne Idee ohne Fertig-Häkchen, auch aus Songs. |

## Version 1: Kern

Version 1 deckt Aufnehmen, Einsortieren, Wiederfinden, Teilen und Sichern ab.

| Funktion | Verhalten |
| --- | --- |
| Schnellaufnahme | Ein Tap auf den großen Button startet die Aufnahme sofort, ein zweiter Tap beendet sie. Zeitpunkt wird automatisch gespeichert. |
| Fenster nach der Aufnahme | Erscheint nach dem Stopp mit Tag-Vorschlägen aus dem Verlauf, Songteil-Auswahl, Notiz und Song-Zuordnung. Ein Tap bestätigt, Überspringen ist erlaubt. Übersprungene Ideen landen in der Inbox. |
| Inbox | Alle Ideen ohne Song. |
| Songs | Song anlegen, Ideen zuordnen oder ergänzen, Notiz am Song. |
| Tags und Suche | Tags an Ideen. Songteil an Ideen: mehrfach wählbar aus einer festen Liste (Standardliste: Intro, Verse, Pre-Chorus, Chorus, Bridge; Einträge in der App änderbar und ergänzbar), auch ohne Song. Filter nach Songteil. Suche über Titel, Tags und Notizen. |
| Notizen | Eine Notiz an jeder Idee und an jedem Song. |
| Fertig-Häkchen | Pro Idee. Ohne Häkchen gilt die Idee als offen. |
| Zufallsidee | Ein Button in der Bibliothek zeigt zufällig eine offene Idee. |
| Teilen | Eine Idee als m4a-Datei über das Share Sheet verschicken. |
| Export und Backup | Siehe Abschnitt Import, Export und Teilen. |

## Version 2

Version 2 ergänzt den Studio-Modus, Vorschläge und den Inspirations-Link, sobald Version 1 im Alltag läuft.

- **Studio-Modus:** Tap Tempo und Einzähler vor der Aufnahme. Das getappte Tempo wird als BPM an der Idee gespeichert.
- **Einzähler wählbar:** visuell, Vibration, Klick über Kopfhörer oder Klick über den Lautsprecher. Standard ist visuell oder Vibration, weil der Lautsprecher-Klick mit aufgenommen wird.
- **Vorschläge nach der Aufnahme:** BPM, Tags aus dem Verlauf und Tonart. Die Tonart wird als "Vorschlag, nicht verlässlich" gekennzeichnet. Wie gut sie bei kurzen Basslinien funktioniert, ist ungeprüft.
- **Inspirations-Songs:** Textfeld und Link zu einem Song an der Idee. Eine Vorschau kommt nur, wenn ein Technik-Check einen sauberen Weg zeigt. Spotify liefert das Vorschau-Feld für neue Apps seit dem 27. November 2024 nicht mehr aus.
- **Vorlauf-Puffer:** Die App hält die letzten 20 bis 30 Sekunden Ton im Arbeitsspeicher und hängt sie vor die Aufnahme. Er kommt erst nach bestandenem Machbarkeitstest, Umfang offen.

* **Loop und Schnitt:** Start- und Endmarke pro Idee, die Aufnahme wird zwischen den Marken wiederholt. Das Original bleibt unverändert. An den Schnittpunkten wird kurz ein- und ausgeblendet, damit der Loop nicht knackt (Annahme, du prüfst es am iPhone).
* **Tempo automatisch erkennen:** Vorschlag neben dem Tap Tempo, mit Umschalter auf halbes und doppeltes Tempo. Ob die Erkennung bei kurzen Basslinien taugt, ist ungeprüft und kommt als Test mit deinen eigenen Aufnahmen vor den Einbau.

- **Tonart manuell und Quintenzirkel:** Die Tonart (Dur oder Moll) lässt sich pro Idee setzen. Ein kompakter Quintenzirkel im Bearbeiten-Fenster dient als Auswahl: Ein Tap setzt die Tonart, der Kreis zeigt das Dur/Moll-Paar, die Nachbartonarten und die Stufenakkorde. Ein Tap auf einen Akkord übernimmt ihn in die Akkordfolge.
- **Akkordfolge:** Liste ohne Zeitbezug an der Idee (zum Beispiel Am, F, C, G), frei bearbeitbar.
- **Akkordvorschläge:** Regelbasiert aus der Musiktheorie (Stufenakkorde der Tonart, übliche Folgen), offline. Eine KI-Option ist offen und wird nach Version 2 entschieden. Zur Wahl stehen das lokale Apple-Modell (braucht iOS 26 und aktiviertes Apple Intelligence) oder ein kostenloser Online-Zugang mit eigenem Schlüssel in den Einstellungen. Vorher prüfst du iOS-Version und Apple Intelligence am iPhone.

## Version 3

Version 3 ergänzt rudimentäre Schlagzeug-Beats, die zum Tempo der Idee passen und mit dem Loop laufen.

- Mehrere Stile in 4/4 (zum Beispiel Rock, Funk). Die Liste der Stile legt Claude Code vor, du bestätigst.
- Der Beat folgt dem Tempo der Idee (getappt oder erkannt) und läuft synchron zum Loop.
- Drum-Klänge sind frei nutzbare Samples oder selbst erzeugt, keine urheberrechtlich geschützten Aufnahmen.
- Andere Taktarten sind nicht vorgesehen.
- Vorher läuft ein Prototyp, der Tempo, Loop und Beat zusammen abspielt.

* **Automatische Akkorderkennung:** Erst nach einem Test mit deinen eigenen Aufnahmen. Das Ergebnis ist ein Vorschlag, manuelle Korrektur ist immer möglich. Für einen einstimmigen Bass ist die Erkennung ungeprüft und möglicherweise unzuverlässig.

## Aufnahme: Muss-Anforderungen

Eine begonnene Aufnahme darf nie verloren gehen.

- Die Aufnahme wird laufend auf das Gerät geschrieben. Nach Absturz, Anruf oder leerem Akku bleibt der bisherige Teil erhalten.
- Bei Unterbrechungen (Anruf, Alarm, Abziehen von Kopfhörer oder Interface) stoppt die App sauber, speichert und zeigt einen Hinweis.
- **Mikrofonquellen:** iPhone-Mikrofon sowie USB-Audio-Interface oder USB-Mikrofon. Bluetooth ist nicht gefordert. Ob die Eingangswahl für Interfaces unter iOS wie gewünscht funktioniert, ist ungeprüft und steht im Prototyp-Test.
- **Format:** Zuerst unkomprimierte Zwischendatei, danach AAC (m4a), siehe Technische Entscheidungen. Bitrate und Abtastrate sind offen, Claude Code schlägt Werte vor.
- Die App fragt die Mikrofon-Berechtigung beim ersten Start ab und erklärt kurz, wofür.

## Import, Export und Teilen

Sprachmemos lassen sich nicht direkt einlesen, der Import läuft über die Dateien-App.

- **Import:** Der Dialog der Dateien-App erlaubt Ordner oder mehrere Dateien auf einmal. Apps von Dritten haben keinen Zugriff auf den Speicher der Sprachmemos. Die Aufnahmen müssen deshalb vorher aus Sprachmemos in die Dateien-App oder in einen Ordner gelangen.
- **Weg über den Mac:** Wenn Sprachmemos mit dem Mac synchronisiert sind, liegen die Aufnahmen dort in einem Ordner und lassen sich als Ganzes aufs iPhone bringen. Ob das bei dir so funktioniert, ist ungeprüft.
- **Aufnahmedatum:** Beim Import wird das Datum der Originaldatei übernommen, sofern vorhanden (Annahme).
- **Export und Backup:** Nach jeder Aufnahme exportiert die App inkrementell (nur Neues und Geändertes) in einen von dir gewählten Ordner. Dazu gibt es einen manuellen Vollexport aller Ideen und Songs mit Metadaten (Audiodateien plus eine Metadaten-Datei). Ein Import dieser Sicherung stellt alles wieder her.
- **Teilen:** Einzelne Idee als m4a über das Share Sheet, ohne Server und ohne Konto.
- **Mac:** Übertragung manuell per AirDrop oder Share Sheet.

## Oberfläche und Navigation

Die App hat zwei Hauptbildschirme (Aufnahme und Bibliothek) und einen Einstellungen-Bildschirm. Die Optik ist minimal wie Sprachmemos mit einem großen Aufnahme-Button.

- **Aufnahme:** Großer Button im Fokus, sonst kaum Elemente. Nach dem Stopp erscheint das kleine Fenster mit Tags, Notiz und Song-Zuordnung.
- **Bibliothek:** Alle Ideen, die Inbox-Ansicht, die Songs, die Suche und der Button für die Zufallsidee.
- **Entwurf: Die Zeichenfläche mit beiden Looks liegt vor (https://claude.ai/artifact/LHVbUa9UN8j7fGru7jxMcP). Feinheiten klärst du mit Claude Code am iPhone**.

## Look und Einstellungen

Die App hat zwei Looks, die du in den Einstellungen umschaltest. Standard ist der Transmitter-Stil, beide sind Teil von Version 1.

- **Transmitter-Stil:** Papierweiß als Grund, Pink, Gelb, Lila und Blau als Akzente, dicke dunkle Konturen, harte Versatzschatten, Anton für Überschriften und Work Sans für den Text. Vorlage ist das EPK der Band.
- **Dunkler Look:** Dunkler Grund, eine rote Akzentfarbe, schlicht und augenschonend.
- **Austauschbare Look-Werte:** Farben, Schriften, Konturdicke, Schatten und Eckenradien liegen an einer zentralen Stelle statt in den einzelnen Bildschirmen. So lässt sich ein Look ändern oder ergänzen, ohne Bildschirme umzubauen.
- **Schriften:** Anton und Work Sans werden in die App eingebunden. Die Lizenz wird vor dem Einbau geprüft, vermutlich ist es die SIL Open Font License.
- **Prüfung:** Beide Looks werden am iPhone auf Lesbarkeit geprüft, auch bei wenig Licht.
- **Einstellungen-Bildschirm:** Erreichbar über ein Symbol in der Kopfzeile der Bibliothek (Annahme). Inhalt in Version 1: Look wählen, Export-Ordner wählen, Vollexport starten, Songteil-Liste bearbeiten, Papierkorb. Der Papierkorb-Bildschirm und die Songteil-Bearbeitung sind noch nicht gezeichnet.

## Prototyp-Tests vor dem Bau

Vier Dinge sind ungetestet und entscheiden, ob die App im Alltag taugt. Sie werden mit kleinen Test-Apps am echten iPhone geprüft. Drei davon laufen vor Version 1, der AltStore-Test läuft parallel.

| Test | Frage | Bestanden, wenn |
| --- | --- | --- |
| AltStore-Refresh | Lässt sich eine selbst gebaute App automatisch erneuern? | Die App läuft 14 Tage, zwei Refreshes, die Daten bleiben erhalten. |
| Aufnahmestart | Startet eine Aufnahme aus Action Button oder Sperrbildschirm? | Aufnahme startet ohne App im Vordergrund. Sonst gilt: Start nur nach Öffnen der App. |
| Hintergrund und Vorlauf-Puffer | Hält iOS einen dauerhaft laufenden Puffer am Leben? | Puffer läuft mindestens 30 Minuten, Akkuverbrauch ist akzeptabel. |
| USB-Audio | Lässt sich ein Interface oder USB-Mikrofon als Eingang wählen? | Aufnahme über das Interface, Eingang wählbar. |

Ein Hinweis aus Entwicklerforen: Eine Aufnahme aus dem Hintergrund per Action Button oder Kurzbefehl startet offenbar nur, wenn die App schon aktiv ist. Das ist nicht aus Apples offizieller Dokumentation belegt.

## Erfolgskriterien

Version 1 gilt als gelungen, wenn alle fünf Aussagen am echten iPhone stimmen.

1. Die Aufnahme läuft maximal 2 Sekunden nach dem Öffnen der App bei entsperrtem iPhone.
2. Bei Anruf, Absturz oder leerem Akku bleibt die bisherige Aufnahme erhalten.
3. 50 Sprachmemos lassen sich aus der Dateien-App in einem Durchgang importieren.
4. Ein Export-Vorgang sichert alle Ideen und Songs mit Metadaten.
5. Die App läuft 14 Tage am Stück, einschließlich zwei AltStore-Refreshes, ohne Datenverlust.

## Annahmen, Risiken und offene Punkte

Drei Punkte hängen an Annahmen, die du noch bestätigen musst: Fertig-Häkchen, Schnitt der Versionen und Mac-Import.

| Punkt | Sicherheit | Folge |
| --- | --- | --- |
| Das Fertig-Häkchen sitzt an der Idee. Ideen in Songs bleiben Kandidaten für die Zufallsidee, bis sie abgehakt sind. | Annahme | Ändert Datenmodell und Zufallsauswahl. |
| Version 1 ist der Kern, der Studio-Modus kommt in Version 2. | Annahme | Ändert den Umfang der ersten Lieferung. |
| Kostenlose Signatur läuft nach 7 Tagen ab, iCloud ist damit nicht möglich. | Sicher | Wöchentliche Erneuerung nötig, kein Sync. |
| Spotify liefert Vorschau-Links für neue Apps nicht mehr. | Sicher | Vorschau im Inspirations-Link nur mit anderem Weg. |
| Sprachmemos sind für Apps von Dritten nicht lesbar. | Wahrscheinlich | Import bleibt Handarbeit über die Dateien-App. |
| Aufnahme aus dem Hintergrund per Action Button startet nur bei aktiver App. | Wahrscheinlich | Schnellstart vom Sperrbildschirm ist riskant. |
| AltStore erneuert die App zuverlässig im Hintergrund. | Wahrscheinlich, nicht sicher | Die App kann ablaufen, wenn der Mac nicht erreichbar ist. |
| Tonart-Erkennung bei kurzen Basslinien. | Vermutung | Vorschlag wird als unsicher gekennzeichnet. |

**Quellen (aus Suchergebnissen, nicht vollständig geprüft):** [Apple Developer: Mitgliedschaften](https://developer.apple.com/support/compare-memberships), [Apple Forum: iCloud in Personal Teams](https://developer.apple.com/forums/thread/811929), [Apple Forum: Aufnahmestart aus dem Hintergrund](https://developer.apple.com/forums/thread/815725), [Apple Forum: Zugriff auf Sprachmemos](https://developer.apple.com/forums/thread/727223), [AltStore FAQ](https://faq.altstore.io/altstore-world/your-altstore), [Spotify Community: Vorschau-Links](https://community.spotify.com/t5/Spotify-for-Developers/Missing-Preview-URL-using-Client-Credentials/m-p/6492694/highlight/true).

## Arbeitsweise für Claude Code

Zuerst drei Prototypen, parallel der AltStore-Test, dann Version 1 in kleinen, einzeln prüfbaren Schritten.

- Nach jedem Schritt wird gebaut und getestet. Claude Code erklärt in einfachen Worten, was entstanden ist und wie du es am iPhone prüfst.
- Wichtige Tests laufen am echten iPhone. Der Simulator bildet Action Button, Hintergrundaufnahme und echtes Mikrofon wahrscheinlich nicht verlässlich ab.
- Das Projekt liegt von Anfang an in Git, mit regelmäßigen Commits.
- Es wird nur gebaut, was in diesem Dokument steht. Bei Lücken fragt Claude Code nach, statt zu raten.
- Kein Schritt darf Ideen löschen oder überschreiben, ohne dass vorher ein Export möglich war.
