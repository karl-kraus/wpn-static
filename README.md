[![Build and publish](https://github.com/karl-kraus/wpn-static/actions/workflows/build.yml/badge.svg)](https://github.com/karl-kraus/wpn-static/actions/workflows/build.yml)

>[!IMPORTANT] 
>This repo is work in progress. Do not open issues (bug reports, feature requests) unless you are currently an active developler in this repo. If you are an active developer in this repo only open issues regarding your own work.

# Dritte Walpurgisnacht Static Edition

Migrating from https://kraus1933.ace.oeaw.ac.at/ [TEI Publisher](https://teipublisher.com/exist/apps/tei-publisher-home/index.html) based Edition to [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter) based Static Edition.

Developers: 
Barbara Krautgartner \
(if you contribute, you can add your name at the end of the list)

## views / pages

| page/view | original instance | current instance | current tei source | current xslt|
|-----|-----|-----|-----|-----|
|Startseite|https://kraus1933.ace.oeaw.ac.at/index.html|https://karl-kraus.github.io/wpn-static/|index.xml|index.xsl|
| Projekt Info | https://kraus1933.ace.oeaw.ac.at/projekt.html |https://karl-kraus.github.io/wpn-static/projekt.html | meta/projekt.xml | meta.xsl |
| Impressum | https://kraus1933.ace.oeaw.ac.at/impressum.html | https://karl-kraus.github.io/wpn-static/impressum.html | meta/impressum.xml | meta.xsl |
| Nutzungsbedingungen | https://kraus1933.ace.oeaw.ac.at/nutzungsbedingungen.html | https://karl-kraus.github.io/wpn-static/nutzungsbedingungen.html | meta/nutzungsbedingungen.xml | meta.xsl |
| Annotierte Lesefassung (Übersicht) | https://kraus1933.ace.oeaw.ac.at/annotierte_lesefassung.html | https://karl-kraus.github.io/wpn-static/annotierte_lesefassung.html | annotierte_lesefassung.xml | meta.xsl |
| Register (Übersicht) | https://kraus1933.ace.oeaw.ac.at/register.html | https://karl-kraus.github.io/wpn-static/register.html | register.xml | register.xsl |
| Notizen | https://kraus1933.ace.oeaw.ac.at/notizen.html | https://karl-kraus.github.io/wpn-static/notizen.html | notizen.xml | notizen.xsl |
| Notizen Konvolut 1 | https://kraus1933.ace.oeaw.ac.at/notizen_konvolut_1.html | https://karl-kraus.github.io/wpn-static/notizen_konvolut_1.html | notizen.xml (content not used, dummy file for xsl transformation) | notizen_konvolut.xsl |
| Notizen Konvolut 2 | https://kraus1933.ace.oeaw.ac.at/notizen_konvolut_2.html | https://karl-kraus.github.io/wpn-static/notizen_konvolut_2.html | notizen.xml (content not used, dummy file for xsl transformation) | notizen_konvolut.xsl |
| Kommentar Übersicht |https://kraus1933.ace.oeaw.ac.at/kommentar.html| https://karl-kraus.github.io/wpn-static/kommentar.html | meta/kommentar.xml | kommentar.xsl |
| Register Intertexte |https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_intertexte.html|https://karl-kraus.github.io/wpn-static/register_intertexte.html|internal index file|register_intertexte.xsl|
| Register Personen |https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_personen.html|https://karl-kraus.github.io/wpn-static/register_personen.html|internal index file|register_personen.xsl|
| Register Stellenkommentar |https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_kommentare.html|https://karl-kraus.github.io/wpn-static/register_kommentare.html|internal index file|register_kommentare.xsl|
| Zeitleiste |https://kraus1933.ace.oeaw.ac.at/ereignisse.html|https://karl-kraus.github.io/wpn-static/ereignisse.html|internal index file|ereignisse.xsl| 
| Edition View - 65 pages |https://kraus1933.ace.oeaw.ac.at/Gesamt.xml|https://karl-kraus.github.io/wpn-static/motti.html|internal edition file|editions.xsl|
| Suche | https://kraus1933.ace.oeaw.ac.at/search.html | https://karl-kraus.github.io/wpn-static/suche.html |suche.xml (no specific content, dummy file for xsl transformation)|search.xsl|


## Development
### prerequisites
if you are not using the included devcontainer, check your dev environment for the neccessary dependencies: python, node, java, java ant

### commands

|   |   |
|---|---|
|start dev server|python3 -m http.server|   
|compile scss|npm run compile-scss|
|(re)build the full edition|ant build-full-edition|  

rebuild single files/groups of files by using the specific target
