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

- **Deckblatt** (Seite 1, schlichtes A4-Layout ohne Faksimile-Optik): Zitationsangabe aus Zeugen-Titel (aus der Info-Spalte der Website, ohne die seitenspezifische ", fol. [...]"-Angabe), gefolgt von "Topographische Transkription. In: Karl Kraus: Dritte Walpurgisnacht. Digitale Edition. Hg. v. Bernhard Oberreither." und der (klickbaren) `PDF_BASE_URL`.
- **Legende** (Seite 2): das "Legende"-Panel aus der Info-Spalte (`#legende-pb`, normalerweise per Klick auf das Legende-Icon eingeblendet), 1:1 wie auf der Website erfasst — inklusive der gesamten Hand-/Tinten-Farbkodierung, Durchstreichungen, Unterstreichungen etc. Inhalt ist für alle Zeugen identisch (Quelle: `data/meta/topographical.xml`), wird daher nur einmal erzeugt und in jede PDF übernommen.
- **Fußzeile** auf jeder Transkriptionsseite: die Quell-URL dieser Seite (ohne Ansichts-Parameter wie `?view=...`, als klickbarer Link) gefolgt vom Datum des Skript-Laufs in eckigen Klammern, z.B. `https://.../wit-HMotto-0001r.html [21.08.2026]`. Das Datum ist für den ganzen Lauf gleich, nicht pro Seite.

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
