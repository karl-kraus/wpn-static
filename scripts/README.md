# PDF-Export der Transkriptionsseiten

`generate-pdfs.mjs` erzeugt pro Textzeuge eine PDF mit allen transkribierten Seiten (`#textcontent-pb`) in Lesereihenfolge, pixelgenau wie auf der Website.

Das Skript läuft unabhängig vom Build; es öffnet die Website in Chromium (Playwright), navigiert von jeder Seite aus über den "Nächste Seite"-Link weiter und hört auf, sobald ein Zeuge zu Ende ist. Es benötigt dafür eine Start-URL pro Zeuge (fest im Skript hinterlegt).

## Voraussetzungen

Einmalig:

```bash
pnpm install
pnpm exec playwright install --with-deps chromium
```

## Starten

Im Projekt-Root:

```bash
node scripts/generate-pdfs.mjs
```

Läuft gegen alle 6 Zeugen, dauert insgesamt ca. 3–7 Minuten (dzt. ges. 346 Seiten).

Ergebnis: `pdf-output/<Zeuge>.pdf` (Ordner wird automatisch angelegt, ist `.gitignore`t).

## Umgebungsvariablen

| Variable | Zweck | Default |
|---|---|---|
| `PDF_BASE_URL` | Basis-URL der Website | `https://karl-kraus.github.io/wpn-static-dev` |
| `PDF_GEN_WITNESS` | nur einen einzelnen Zeugen generieren (Name wie in `WITNESSES` im Skript, z.B. `TFragment2`) | alle 6 |

Beispiele:

```bash
# nur einen Zeugen
PDF_GEN_WITNESS=TFragment2 node scripts/generate-pdfs.mjs

# gegen einen lokalen Server statt der Live-Seite
PDF_BASE_URL=http://127.0.0.1:8080 node scripts/generate-pdfs.mjs
```

## Ausgabe lesen

Am Ende gibt das Skript eine Zusammenfassung aus:

- `[done] <Zeuge>: N Seiten -> pdf-output/<Zeuge>.pdf` — erfolgreich erzeugt.
- `[failed] <Zeuge>: ...` — Start-URL nicht erreichbar (z.B. weil dieser Zeuge auf der Ziel-Instanz noch nicht deployt ist) oder eine Seite mittendrin ist ausgefallen. Ein Fehlschlag bei einem Zeugen verwirft nicht die bereits fertigen anderen; Exit-Code ist dann `1`.
- Überlauf-Zusammenfassung: Seiten, deren Inhalt über das nominelle physische Format hinausragt (z.B. Randnotizen), werden automatisch vergrößert (`grow`, Default) oder verkleinert (`shrink`, siehe unten). Bei Überlauf über 10 cm pro Kante wird stattdessen geklippt und die Seite in einer eigenen `[!] ... CAPPED`-Liste genannt — das betrifft meist einen bekannten, nicht hier behobenen Rendering-Sonderfall (siehe `tei:seg[@type='F890']` im Plan-Dokument), kein Fehler im Skript selbst.

## Deckblatt und Fußzeile

Jede erzeugte PDF enthält automatisch:

- **Deckblatt** (Seite 1, schlichtes A4-Layout ohne Faksimile-Optik): Inhalt kommt pro Textzeuge (und für `generate-lesefassung-pdf.mjs` auch für die Lesefassung) aus `scripts/pdf-cover-info.json`, nicht mehr von der Website gescrapt. Jeder Eintrag hat `text` (beliebiger Fließtext für die Zitationsangabe; ein `\n` darin wird als Zeilenumbruch gerendert), `url` (nur der letzte Pfad-Teil — wird an `PDF_BASE_URL` angehängt — als klickbarer Link, an den das Datum des Skript-Laufs `[YYYY-MM-DD]` angehängt wird) und optional `facsurl` (volle externe URL, z.B. Permalink einer Bibliothek; wird danach in eigener Zeile als "Faksimiles unter: ..." angegeben). Fehlt ein Eintrag für einen Zeugen, wird für dessen PDF kein Deckblatt erzeugt (Warnung im Log); fehlt der `"Lesefassung"`-Eintrag, fällt `generate-lesefassung-pdf.mjs` auf einen generischen Text zurück.
- **Legende** (Seite 2, gleiche A4-Größe wie das Deckblatt): das "Legende"-Panel aus der Info-Spalte (`#legende-pb`, normalerweise per Klick auf das Legende-Icon eingeblendet), 1:1 wie auf der Website erfasst — inklusive der gesamten Hand-/Tinten-Farbkodierung, Durchstreichungen, Unterstreichungen etc. — und proportional (ohne Verzerrung) auf die A4-Seite skaliert und zentriert. Inhalt ist für alle Zeugen identisch (Quelle: `data/meta/topographical.xml`), wird daher nur einmal erzeugt und in jede PDF übernommen.
- **Fußzeile** auf jeder Transkriptionsseite: die Quell-URL dieser Seite (ohne Ansichts-Parameter wie `?view=...`, als klickbarer Link) gefolgt vom Datum des Skript-Laufs in eckigen Klammern, z.B. `https://.../wit-HMotto-0001r.html [21.08.2026]`. Das Datum ist für den ganzen Lauf gleich, nicht pro Seite.

## Deckblatt-Inhalte pflegen: `pdf-cover-info.json`

```json
{
  "DfeH": {
    "text": "Erste Zeile der Zitationsangabe.\nZweite Zeile.\nDritte Zeile.",
    "url": "wit-DfeH-0001r.html",
    "facsurl": "https://beispiel-bibliothek.at/permalink/xyz"
  },
  "Lesefassung": {
    "text": "Zitationsangabe der Lesefassung...",
    "url": "annotierte_lesefassung.html"
  }
}
```

- Ein Eintrag pro Zeuge, Schlüssel = Zeugen-Name wie in `WITNESSES` im Skript (`DfeH`, `TFragment2`, `HMotto`, `DfMotto`, `TParalipomenon`, `DffH`), plus ein eigener Eintrag `"Lesefassung"` für `generate-lesefassung-pdf.mjs`.
- `text`: Fließtext der Zitationsangabe. Darf HTML enthalten (z.B. `<sup>...</sup>`); ein `\n` wird als Zeilenumbruch (`<br/>`) gerendert.
- `url`: **nur der letzte Teil des Pfads** (kein `PDF_BASE_URL`-Präfix) — das Skript setzt `PDF_BASE_URL` selbst davor. Erscheint als klickbarer Link direkt nach dem Text, gefolgt vom Datum des Skript-Laufs in eckigen Klammern (gleiches Datum wie in der Fußzeile).
- `facsurl` (optional): volle, eigenständige URL (nicht mit `PDF_BASE_URL` kombiniert) zu einem externen Faksimile-Nachweis, z.B. bei einer Bibliothek. Erscheint, falls gesetzt, in eigener Zeile direkt nach der `url`-Zeile als "Faksimiles unter: [facsurl]".
- Fehlt der Eintrag für einen Zeugen, wird für dessen PDF kein Deckblatt erzeugt (Warnung im Log, restliche PDF-Erstellung läuft unverändert weiter). Fehlt `"Lesefassung"`, verwendet `generate-lesefassung-pdf.mjs` stattdessen einen generischen Zitationstext.

## Sonderfälle konfigurieren: `pdf-page-overrides.json`

Für einzelne Zeugen oder Seiten lässt sich das Überlauf-Verhalten überschreiben, ohne das Skript selbst anzufassen:

```json
{
  "defaults": { "overflowStrategy": "grow", "maxShrinkPercent": 15 },
  "witnesses": {
    "HMotto": { "overflowStrategy": "shrink", "maxShrinkPercent": 10 }
  },
  "pages": {
    "wit-DfeH-0231r": { "heightOverrideCm": 23.4 }
  }
}
```

- `overflowStrategy`: `"grow"` (Default, Seite wird größer) oder `"shrink"` (Inhalt wird verkleinert, gedeckelt durch `maxShrinkPercent`; reicht das nicht, fällt es automatisch auf `grow` zurück).
- `heightOverrideCm` / `widthOverrideCm`: feste Maße für eine einzelne Seite (Seiten-ID = Dateiname ohne `.html`, z.B. `wit-DfeH-0231r`), überstimmt die automatische Berechnung komplett.

# PDF-Export der Timeline

`generate-timeline-pdf.mjs` erzeugt aus der interaktiven Ereignisse-Timeline (`timeline.html`, AnyChart-Widget `<wpn-time-line>`) eine PDF mit einer einzigen, sehr breiten Seite bei möglichst feiner (tageweiser) horizontaler Auflösung — nicht paginiert wie die beiden Skripte oben, sondern eine Seite, deren Maße direkt vom abgedeckten Zeitraum abhängen.

Die Daten reichen zwar vom Jahr 37 bis Oktober 1933, aber bis auf gut zehn vereinzelte "Historische Referenzen" liegt fast alles lückenlos zwischen 1914 und 1933. Ein durchgehender linearer Zeitstrahl über den vollen ~1900-Jahre-Bereich würde bei dieser Auflösung eine viele Meter breite, größtenteils leere Fläche ergeben, nur um die paar antiken Ausreißer mitabzudecken. Das Skript rendert deshalb nur den dichten Kernzeitraum (Default: ab 1914) auf dem Zeitstrahl selbst; die älteren Ereignisse werden auf einer eigenen Anhangsseite gelistet — mit demselben Titel-/Datums-/Kategorietext, der auf der Website ohnehin schon für die (normalerweise per Hover eingeblendete) Registerkarte jedes Ereignisses gerendert wird.

## Starten

```bash
node scripts/generate-timeline-pdf.mjs
```

Ergebnis: `pdf-output/Timeline.pdf` (Deckblatt, die eine große Zeitstrahl-Seite, ggf. Anhangsseite mit den älteren Ereignissen).

## Umgebungsvariablen

| Variable | Zweck | Default |
|---|---|---|
| `PDF_BASE_URL` | Basis-URL der Website | `https://karl-kraus.github.io/wpn-static-dev` |
| `PDF_TIMELINE_DENSE_START` | ISO-Datum; Ereignisse davor wandern in den Anhang statt auf den Zeitstrahl | `1914-01-01` |
| `PDF_TIMELINE_PX_PER_DAY` | horizontale Pixeldichte des Kernzeitraums (Ausgangspunkt vor dem 8pt-Fitting) | `5` (≈ die Dichte der Standardansicht der Website: 850px / 182 Tage) |
| `PDF_TIMELINE_TARGET_PT` | Zielgröße für die kleinste dargestellte Schrift, in pt | `8` |
| `PDF_TIMELINE_MAX_WIDTH_CM` | Sicherheitsobergrenze für die Seitenbreite, bevor auf die Zielschriftgröße skaliert wird | `1200` (≈ 12m) |

Wird `PDF_TIMELINE_MAX_WIDTH_CM` erreicht, gibt das Skript eine Warnung aus — die angeforderte Pixeldichte konnte dann nicht vollständig eingehalten werden (eher `PDF_TIMELINE_PX_PER_DAY` senken als die Grenze anheben, außer es ist bereits geprüft, dass Chromium eine noch größere Seite drucken kann).

**Hinweis:** Das resultierende PDF ist eine einzelne, potenziell mehrere Meter breite Seite — das Skript wurde nicht in einer Umgebung mit sichtbarem Browser-Rendering entwickelt/verifiziert. Ergebnis nach dem ersten Lauf unbedingt visuell prüfen (Überlappungen, Zeilenumbrüche, tatsächliche Schriftgröße) und bei Bedarf über die Umgebungsvariablen nachjustieren.
