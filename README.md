# 🌍 Talmora

### Ein textbasiertes Survival-RPG -- eine Welt, zwei Plattformen und jede Menge Abenteuer.

**Talmora** ist ein umfangreiches textbasiertes Survival-RPG, das die
Freiheit, Erkundung und viele Spielmechaniken eines
Minecraft-inspirierten Sandbox-Spiels mit einer klassischen RPG-Engine
verbindet.

Das Projekt baut auf einer bereits bestehenden und umfangreichen
**RPG-Core-Engine für mIRC** auf. Diese stellt unter anderem
Charakterverwaltung, Kämpfe, Fähigkeiten, Gegner, Bosse, Dungeons und
weitere RPG-Systeme bereit.

Talmora erweitert diese Grundlage um eine persistente, frei erkundbare
Welt mit Biomen, Ressourcen, Survival-Mechaniken, Landwirtschaft,
Tierhaltung, NPCs, Quests und vielen weiteren geplanten Systemen.

Ursprünglich war das Projekt ausschließlich für **IRC** vorgesehen. Mit
**Redstone Relay** entsteht zusätzlich eine Anbindung an Discord.
Langfristig sollen Spieler über beide Plattformen auf dieselbe Welt und
dieselben zentralen Spielsysteme zugreifen können.

> **Eine Welt. Zwei Plattformen. Deine Geschichte.**

------------------------------------------------------------------------

## 📖 Die Idee hinter Talmora

Minecraft besteht aus weit mehr als dem Platzieren und Abbauen von
Blöcken.

Erkundung, Survival, Ressourcen, Landwirtschaft, Tiere, Kämpfe und die
Freiheit, seinen eigenen Weg durch eine große Welt zu finden, gehören
ebenso dazu.

Talmora versucht, dieses Spielgefühl in ein vollständig **textbasiertes
RPG** zu übertragen.

Dabei soll keine exakte Kopie jedes einzelnen Minecraft-Befehls
entstehen. Stattdessen verbindet das Projekt bekannte Inspirationen mit
klassischen RPG-Elementen und eigenen Ideen.

Dazu gehören unter anderem eigene Monster, Fähigkeiten, NPCs, Quests,
Dungeons, Ereignisse und möglicherweise eine zusammenhängende
Geschichte.

------------------------------------------------------------------------

## 🗺️ Eine persistente Welt

Talmora besitzt eine gemeinsame persistente Spielwelt.

Spieler bewegen sich nicht lediglich zwischen vorgegebenen Menüpunkten,
sondern besitzen eine tatsächliche Position innerhalb der Welt.
Regionen, Biome, Höhen und andere Eigenschaften bestimmen, was ein
Spieler an seinem aktuellen Standort erleben kann.

Zu den bereits vorhandenen beziehungsweise im Aufbau befindlichen
Grundlagen gehören:

-   persistente Spielerpositionen und Koordinaten
-   größere zusammenhängende Regionen
-   unterschiedliche Biome
-   Oberflächenhöhen und Gebirge
-   verschiedene Bewegungsarten
-   globale Tageszeit
-   Tage und Mondphasen
-   Grundlagen für Wetter
-   zufällige Weltereignisse
-   zufällige Monsterbegegnungen

Langfristig soll neben der Oberfläche auch eine umfangreiche Erkundung
des Untergrunds möglich werden.

------------------------------------------------------------------------

## 🚶 Erkundung und Bewegung

Die Bewegung durch Talmora hängt von Gelände und Situation ab.

Normale Bewegung und Sprinten unterscheiden sich bereits in ihrer
Reichweite. Gebirge besitzen eigene Regeln und können nicht einfach wie
normales Gelände durchquert werden. Dafür befindet sich ein eigenes
Bergsteigesystem in Entwicklung.

Langfristig sollen Bewegung und Erkundung außerdem mit weiteren Systemen
verbunden werden, beispielsweise Hunger, Wetter, Tageszeit, Gelände,
Statusveränderungen, Ressourcen und besonderen Weltereignissen.

Während eines laufenden Kampfes soll keine normale Welterkundung möglich
sein. Bewegungsaktionen wie Laufen, Sprinten oder Bergsteigen werden in
dieser Situation blockiert, damit während einer aktiven Begegnung keine
weitere unabhängige Begegnung ausgelöst werden kann.

------------------------------------------------------------------------

## ⚔️ RPG und Kampfsystem

Talmora verwendet die bereits vorhandene **Battle-Engine des RPG-Core**.

Dadurch muss kein vollständig neues Kampfsystem entwickelt werden.
Talmora kann Monsterbegegnungen an die vorhandene Engine übergeben,
welche anschließend den eigentlichen Kampf verwaltet.

Die Core-Engine stellt bereits zahlreiche Mechaniken bereit, darunter
Charakterwerte, Schaden, Statusveränderungen, Fähigkeiten, Items sowie
verschiedene Arten von Gegnern und Kämpfen.

### ⚠️ Eine zentrale Kampfbegegnung

Die vorhandene Battle-Engine verwaltet derzeit einen **zentralen
globalen Kampfzustand**. Dadurch kann immer nur **eine unabhängige
Kampfbegegnung gleichzeitig** aktiv sein.

Bei einer normalen Talmora-Erkundungsbegegnung wird derzeit **ein
Encounter-Monster ausgewählt und an die Battle-Engine übergeben**. Der
daraus entstehende Kampf beginnt entsprechend mit diesem einzelnen
Gegner.

Die zugrunde liegende Core-Engine ist jedoch grundsätzlich in der Lage,
innerhalb einer laufenden Kampfbegegnung weitere Gegner zu verwalten.
Dafür müssten entweder mehrere Gegner für die Begegnung vorgesehen
werden oder ein bereits kämpfender Gegner müsste beispielsweise über
eine Fähigkeit wie **Monster Summon** zusätzliche Monster beschwören.

Solche zusätzlichen Gegner gehören weiterhin zur **gleichen laufenden
Kampfbegegnung** und erzeugen keinen zweiten unabhängigen Kampf.

Erst nachdem die aktive Begegnung vollständig beendet wurde, kann eine
neue unabhängige Begegnung gestartet werden.

Da IRC und Discord zukünftig dieselbe zentrale RPG-Core-Engine
verwenden, gilt diese Einschränkung plattformübergreifend.

### 🌑 Darkness -- Schutz vor Endloskämpfen

Die Battle-Engine verfügt über einen besonderen Sicherheitsmechanismus
namens **Darkness**.

Kämpfe dürfen nicht unbegrenzt andauern. Abhängig von der jeweiligen
Begegnung steht eine begrenzte Anzahl an Kampfrunden zur Verfügung.

Dieser Mechanismus entstand ursprünglich, weil bestimmte Gegner --
beispielsweise durch wiederholtes Heilen -- einen Kampf über einen
extrem langen Zeitraum aufrechterhalten konnten.

Wird das vorgesehene Rundenlimit überschritten, aktiviert die Engine
Darkness. Die Monsterseite erhält dann eine überwältigende Stärke. Der
verursachte Schaden ist darauf ausgelegt, die Begegnung unmittelbar zu
beenden und kann nicht durch normale Ausweich- oder
Verteidigungsmechaniken verhindert werden.

Ein Sieg über den Gegner ist ab diesem Zeitpunkt nicht mehr vorgesehen.

Bei einer gewöhnlichen Begegnung kann ein solches Limit beispielsweise
bei **15 Runden** liegen. Die tatsächliche Grenze kann jedoch von der
jeweiligen Kampfart abhängen.

Darkness ist daher kein regulärer Schwierigkeitsgrad, sondern ein
**Failsafe der Battle-Engine gegen festgefahrene oder endlose Kämpfe**.

------------------------------------------------------------------------

## 🧙 Charaktere und Entwicklung

Jeder Spieler soll seinen eigenen Charakter erstellen und langfristig
weiterentwickeln können.

Dabei greift Talmora auf die vorhandenen RPG-Grundlagen zurück und
erweitert diese im Laufe der Entwicklung um zusätzliche Mechaniken.

Dazu gehören beziehungsweise sind langfristig vorgesehen:

-   Charaktererstellung
-   Attribute und Charakterwerte
-   Level und Fortschritt
-   Waffen
-   Fähigkeiten und Techniken
-   ein eigenes Skillsystem
-   Statusveränderungen
-   Ausrüstung
-   Items und Inventar
-   langfristige Charakterentwicklung

------------------------------------------------------------------------

## 🍗 Survival und Hunger

Survival soll ein wichtiger Bestandteil von Talmora werden.

Dazu gehört insbesondere ein eigenes **Hungersystem**. Bewegung und
körperlich anstrengende Tätigkeiten sollen Nahrung verbrauchen.
Unterschiedliche Aktionen können dabei unterschiedlich viel Hunger
verursachen.

Sprinten soll beispielsweise mehr Nahrung verbrauchen als normale
Bewegung, während andere Fortbewegungsmöglichkeiten möglicherweise
keinen oder einen eigenen Verbrauch besitzen.

Ist ein Charakter zu hungrig, sollen bestimmte Aktionen blockiert
werden, bis der Spieler Nahrung zu sich genommen hat.

Die genauen Werte und Regeln werden während der weiteren Entwicklung und
durch Tests festgelegt.

------------------------------------------------------------------------

## ⛏️ Rohstoffe und Bergbau

Spieler sollen die Welt nicht nur erkunden, sondern auch ihre Ressourcen
nutzen können.

Geplant sind unter anderem:

-   Holzfällen
-   Rohstoffsammlung
-   Bergbau
-   unterschiedliche Erze und Materialien
-   unterirdische Erkundung
-   Verarbeitung von Ressourcen
-   Crafting
-   Ausrüstung
-   Werkzeuge
-   Waffen

Der Untergrund soll langfristig einen eigenen bedeutenden Teil der
Spielwelt bilden und nicht lediglich eine einzelne Bergbauaktion
darstellen.

------------------------------------------------------------------------

## 🌾 Landwirtschaft und Tierhaltung

Auch Landwirtschaft soll Bestandteil der persistenten Welt werden.

Geplant sind beispielsweise Felder, verschiedene Nutzpflanzen, Aussaat,
Wachstum, Ernte, Nahrung, Tierhaltung und Tierzucht sowie die Gewinnung
tierischer Ressourcen.

Diese Systeme sollen langfristig mit Hunger, Handel, Crafting und
anderen Bereichen des Spiels verbunden werden.

------------------------------------------------------------------------

## 👹 Monster und Begegnungen

Die Welt von Talmora soll nicht ungefährlich sein.

Neben bekannten Minecraft-inspirierten Kreaturen können auch eigene
RPG-Gegner auftreten. Dazu können beispielsweise Zombies, Skelette,
Creeper, mutierte Zombies, mutierte Skelette, Skelettpferde, biomeigene
Kreaturen, seltene Gegner, Elitegegner und Monsterwellen gehören.

Biome, Tageszeit, Wetter und andere Weltzustände können langfristig
Einfluss darauf haben, welchen Gefahren ein Spieler begegnet.

------------------------------------------------------------------------

## 🐉 Bosse und Endgame

Neben gewöhnlichen Gegnern sollen auch mächtige Bosse und
Endgame-Herausforderungen Bestandteil von Talmora werden.

Als Inspiration beziehungsweise geplante Begegnungen kommen unter
anderem bekannte Gegner wie **Ender Dragon**, **Wither** und **Warden**
in Betracht.

Zusätzlich kann Talmora eigene RPG-Bosse und besondere Gegner erhalten.
Dungeons, besondere Belohnungen, Questreihen und andere
Herausforderungen sollen langfristig weitere Endgame-Inhalte bilden.

------------------------------------------------------------------------

## 🧙‍♂️ NPCs, Handel und Quests

Nicht alles in Talmora möchte den Spieler sofort auffressen.

*Zumindest ist das der Plan.*

NPCs sollen der Welt zusätzliche Persönlichkeit und Struktur geben.

Geplant sind unter anderem Gespräche und Interaktionen, Händler, Kaufen
und Verkaufen, Aufgaben, Quests, Erkundungsaufträge, besondere
NPC-Ereignisse, Dungeon-Aufgaben sowie mögliche Story- und Hauptquests.

Ob und in welchem Umfang Talmora eine zusammenhängende Hauptgeschichte
erhält, wird im weiteren Verlauf der Entwicklung entschieden.

------------------------------------------------------------------------

## 🏰 Dungeons

Die zugrunde liegende RPG-Core-Engine verfügt bereits über
Dungeon-Mechaniken.

Talmora soll diese Grundlage langfristig nutzen und um eigene Dungeons
erweitern. Dungeons können besondere Gegner, Bosse, Aufgaben, Ressourcen
und Belohnungen enthalten und einen Gegenpol zur freien Erkundung der
offenen Welt bilden.

------------------------------------------------------------------------

## 🧩 Bestehende RPG-Core-Systeme

Talmora baut nicht auf einer leeren Grundlage auf.

Die vorhandene RPG-Core-Engine enthält neben dem Kampfsystem bereits
zahlreiche weitere Module und Mechaniken. Dazu gehören beispielsweise
Dungeons, Bosse, Bounties sowie besondere Ereignis- und Sammelsysteme.

Auch spezielle bestehende Mechaniken wie die Suche nach den **Dragon
Balls** und der Aufruf von **Shenron** gehören zum vorhandenen Core.

Nicht jedes dieser Systeme muss später automatisch ein zentraler
Bestandteil der eigentlichen Talmora-Spielwelt sein.

Bestehende Core-Komponenten werden jedoch grundsätzlich nicht ohne
vorherige Prüfung entfernt oder deaktiviert. Zwischen den verschiedenen
Modulen der ursprünglichen Engine können Abhängigkeiten bestehen, die
für andere Systeme benötigt werden.

**Der bestehende Core bleibt daher die technische RPG-Grundlage. Talmora
erweitert ihn, anstatt ihn unnötig auseinanderzunehmen.**

------------------------------------------------------------------------

## 🌐 IRC und Discord

Talmora war ursprünglich als IRC-Spiel konzipiert. Dieses Konzept wird
inzwischen erweitert.

Die zentrale Spiel- und RPG-Logik bleibt in der bestehenden Core-Engine.
Zusätzlich entsteht mit **Redstone Relay** eine Brücke zu Discord.

Langfristig ergibt sich folgende Struktur:

``` text
                    ┌─────────────────────┐
                    │       Talmora       │
                    │ RPG-Core + Spielwelt│
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
               ┌────▼────┐          ┌─────▼─────┐
               │   IRC   │          │  Discord  │
               │  mIRC   │          │ Redstone  │
               │         │          │   Relay   │
               └─────────┘          └───────────┘
```

IRC und Discord sollen **keine zwei getrennten Spiele** erhalten.

Beide Plattformen sollen langfristig dieselbe Welt, dieselben Charaktere
und dieselben zentralen Spielsysteme verwenden.

Redstone Relay soll dabei keine zweite RPG-Engine implementieren. Seine
Aufgabe besteht darin, zwischen Discord und dem eigentlichen
Talmora/Core-System zu vermitteln und Ergebnisse für Discord passend
darzustellen.

Discord dient darüber hinaus als Plattform, um die Entwicklung zu
verfolgen und neue Funktionen gemeinsam zu testen.

------------------------------------------------------------------------

## 🗺️ Roadmap

Talmora befindet sich in aktiver Entwicklung.

Die folgende Übersicht beschreibt den aktuellen Stand und die derzeit
vorgesehenen nächsten Systeme. Sie ist keine feste
Veröffentlichungsreihenfolge; einzelne Bereiche können während der
Entwicklung verändert oder neu priorisiert werden.

  -----------------------------------------------------------------------
  System                              Status
  ----------------------------------- -----------------------------------
  RPG-Core                            ✅ Vorhanden

  Battle-Engine                       ✅ Vorhanden

  Charaktergrundsystem                ✅ Vorhanden

  Persistente Talmora-Welt            ✅ Implementiert

  Koordinaten und Regionen            ✅ Implementiert

  Biome                               ✅ Implementiert

  Normale Bewegung (`!move`)          ✅ Implementiert

  Sprinten (`!sprint`)                ✅ Implementiert

  Tageszeit, Tage und Mondphasen      ✅ Implementiert

  Monster-Encounter-Auswahl           ✅ Implementiert

  Übergabe von Talmora-Encountern an  ✅ Implementiert
  die Battle-Engine                   

  Minecraft-/Talmora-Respawn nach     ✅ Implementiert
  Niederlage                          

  Status- und Schadenseffekte bei     🚧 In Entwicklung
  Weltereignissen                     

  Zufällige Weltereignisse            🚧 In Entwicklung

  Gebirge und Bergsteigen (`!hike`)   🚧 In Entwicklung

  Wetter                              🚧 In Entwicklung

  Discord-Spielanbindung über         🚧 In Entwicklung
  Redstone Relay                      

  Hunger und Nahrung                  📋 Geplant

  Bergbau und Untergrund              📋 Geplant

  Holzfällen und Rohstoffsammlung     📋 Geplant

  Farming und Pflanzenanbau           📋 Geplant

  Tierhaltung und Tierzucht           📋 Geplant

  Crafting und Ressourcenverarbeitung 📋 Geplant

  NPCs und Handel                     📋 Geplant

  Quests und Story                    📋 Geplant

  Talmora-Dungeons                    📋 Geplant

  Monsterwellen                       📋 Geplant

  Talmora-Bosse und Endgame           📋 Geplant
  -----------------------------------------------------------------------

**Legende:**\
✅ Implementiert / vorhanden\
🚧 In Entwicklung oder teilweise umgesetzt\
📋 Geplant

------------------------------------------------------------------------

## 🛠️ Installation

> **Hinweis:** Talmora befindet sich noch in einem frühen
> Entwicklungsstadium. Die Installation richtet sich derzeit in erster
> Linie an Entwickler und Tester.

### Voraussetzungen

Für den derzeitigen IRC-Betrieb werden unter anderem benötigt:

-   Windows
-   mIRC
-   eine IRC-Verbindung beziehungsweise ein geeigneter IRC-Server
-   das Talmora-Projekt einschließlich der benötigten RPG-Core-Dateien

Die Discord-Spielanbindung befindet sich noch in Entwicklung und
benötigt zusätzlich **Redstone Relay**.

### Repository klonen

Nach Veröffentlichung des offiziellen GitHub-Repositorys kann das
Projekt beispielsweise mit Git geklont werden:

``` bash
git clone <URL-DES-TALMORA-REPOSITORYS>
```

Anschließend muss die lokale mIRC-Installation entsprechend eingerichtet
und die benötigten Skripte geladen beziehungsweise konfiguriert werden.

Eine vollständige Installations- und Konfigurationsanleitung wird
ergänzt, sobald der Installationsablauf für externe Tester ausreichend
stabilisiert wurde.

------------------------------------------------------------------------

## 💾 Laufzeitdaten und lokale Dateien

Ein Teil der Talmora-Daten verändert sich während des laufenden Spiels
permanent. Dazu gehört insbesondere der aktuelle Zustand der
persistenten Welt.

Solche Laufzeitdaten gehören nicht zum eigentlichen Quellcode und werden
daher nicht vollständig über Git versioniert. Für benötigte
Ausgangszustände können stattdessen Vorlagen beziehungsweise
Default-Dateien bereitgestellt werden.

Persönliche Charakterdateien, lokale mIRC-Konfigurationen, Logs,
Projektarchive und andere lokale beziehungsweise laufzeitabhängige
Dateien sind ebenfalls nicht für die Versionsverwaltung vorgesehen.

Zugangsdaten und andere Geheimnisse gehören grundsätzlich nicht in das
Repository.

------------------------------------------------------------------------

## 🧪 Entwicklung und Tests

Talmora wird schrittweise entwickelt.

Neue Systeme werden möglichst zunächst einzeln implementiert und
praktisch getestet, bevor weitere darauf aufbauende Funktionen
hinzukommen.

Ein wichtiger Grundsatz des Projekts lautet:

> **Der aktuelle Code ist die Wahrheit.**

Ältere Dokumentationen, Planungen und Ideen können vom tatsächlichen
Entwicklungsstand abweichen. Deshalb werden vorhandene Funktionen
möglichst anhand des aktuellen Codes und durch praktische Tests
überprüft.

Die vorhandene RPG-Core-Engine wird dabei nicht unnötig umgebaut.
Bestehende Module können untereinander Abhängigkeiten besitzen und
werden deshalb nur nach entsprechender Prüfung verändert.

------------------------------------------------------------------------

## 🎮 Talmora selbst ausprobieren

Du möchtest Talmora ausprobieren, ohne das komplette Projekt selbst installieren und betreiben zu müssen?

Die aktuelle Entwicklungsversion läuft auf dem offiziellen **iGameRPG-IRC-Server** und kann dort direkt getestet werden.

### Über IRC

Verbinde dich mit folgenden Daten:

- **Server:** `igamerpg.de`
- **Port:** `6697` (SSL/TLS)
- **Spielkanal:** `#RPG-MC`

Zum Verbinden kannst du beispielsweise einen IRC-Client wie **mIRC** verwenden.

Nach der Verbindung mit dem Server kannst du den Spielkanal betreten:

```text
/join #RPG-MC

Dort läuft die aktuelle Entwicklungsversion von Talmora zusammen mit der zugrunde liegenden RPG-Core-Engine.

# Hinweis: Talmora befindet sich in aktiver Entwicklung.

Funktionen können noch unvollständig sein, sich während der Entwicklung verändern oder gelegentlich Fehler verursachen. Genau deshalb sind Tester willkommen.

Wenn dir beim Spielen ein Fehler auffällt, kannst du anschließend ein GitHub Issue erstellen. Hilfreich sind dabei eine möglichst genaue Beschreibung, der verwendete Befehl und – falls vorhanden – die angezeigte Fehlermeldung.

# Über Discord

Eine direkte Spielanbindung über Discord befindet sich derzeit noch in Entwicklung.

Redstone Relay verbindet Discord bereits mit der Entwicklung rund um Talmora. Langfristig soll darüber auch das eigentliche Spiel erreichbar werden.

IRC und Discord sollen dabei keine getrennten Spielwelten erhalten: Beide Plattformen sollen auf dieselben Charaktere, dieselbe Welt und dieselben zentralen RPG-Systeme zugreifen.

------------------------------------------------------------------------

## 🤝 Mitmachen und testen

Talmora befindet sich noch mitten in der Entwicklung.

Viele der beschriebenen Systeme sind daher noch nicht verfügbar oder nur
teilweise umgesetzt.

Das Repository soll dazu dienen, die Entwicklung nachvollziehbar zu
machen, Änderungen zu dokumentieren und später auch gemeinsames Testen
zu erleichtern.

Fehlerberichte, Ideen und Verbesserungsvorschläge können nach
Veröffentlichung des Projekts über **GitHub Issues** gesammelt werden.

------------------------------------------------------------------------

## 📜 Herkunft und Lizenzierung

Talmora baut auf einer bereits bestehenden RPG-Core-Engine auf und
erweitert diese um eigene Systeme für Welt, Survival, Erkundung und
weitere Minecraft-inspirierte Spielmechaniken.

Informationen über Herkunft und Lizenzierung der ursprünglichen
Core-Komponenten sowie über die Lizenz der Talmora-Erweiterungen müssen
vor einer endgültigen öffentlichen Veröffentlichung des Projekts
eindeutig dokumentiert werden.

**Minecraft** ist eine Marke von Mojang Studios. Talmora ist ein
unabhängiges Fanprojekt und steht nicht in Verbindung mit oder unter
offizieller Unterstützung von Mojang Studios oder Microsoft.

------------------------------------------------------------------------

## 🌄 Willkommen in Talmora

> Eine unbekannte Welt liegt vor dir.
>
> Wälder, Gebirge und fremde Regionen warten darauf, entdeckt zu werden.
> Unter deinen Füßen verbergen sich Rohstoffe -- und vielleicht Dinge,
> die besser unentdeckt geblieben wären.
>
> Monster durchstreifen die Welt. Dungeons warten auf ihre ersten
> Abenteurer. Irgendwo am Horizont liegen Herausforderungen, für die ein
> frisch erstellter Charakter noch lange nicht bereit ist.
>
> Und solltest du eines Tages in einer viel zu langen Schlacht einem
> Monster gegenüberstehen, das sich zum achten Mal wieder geheilt hat
> ...
>
> **... nun, dann wird es langsam dunkel. 🌑**
>
> **Deine Reise durch Talmora hat gerade erst begonnen.**
