# IRC-Minecraft

Minecraft Survival als textbasiertes RPG für IRC.

## Grundidee

Die Spieler bewegen sich durch eine gemeinsame, theoretisch unbegrenzte Welt und erleben Minecraft-Survival als textbasiertes Spiel.

Die Welt, Biome, Wetter, Monster, Ressourcen, Kämpfe und Ereignisse werden durch ein datenbasiertes System gesteuert.

## Welt

* Eine gemeinsame Welt für alle Spieler.
* Die Welt ist theoretisch unbegrenzt.
* Spieler erhalten bei der Registrierung einen zufälligen Startpunkt.
* Der Startpunkt besteht aus zufälligen X/Z-Koordinaten und einem zufällig bestimmten Startbiom.
* Die Y-Koordinate der Oberfläche wird vom Weltsystem bestimmt.
* Ein Seed ist nicht erforderlich.

## Bewegung

Der zentrale Bewegungsbefehl ist:

`!move`

Der Spieler gibt keine Himmelsrichtung vor.

Das System bestimmt zufällig:

* Bewegungsrichtung
* zurückgelegte Entfernung
* mögliche Ereignisse während der Reise
* das erreichte Gebiet bzw. Biom

### Oberirdische Bewegung

Die Bewegung erfolgt über größere Entfernungen, beispielsweise zunächst:

`30–500+ Blöcke`

Bei einer längeren Bewegung können mehrere Biome durchquert werden, ohne dass jedes durchquerte Biom zwingend als eigenes Ereignis ausgegeben wird.

### Unterirdische Bewegung

Unter bestimmten Y-Koordinaten kann `!move` auch unterirdisch verwendet werden.

Die zurückgelegte Entfernung ist dort wesentlich geringer, beispielsweise:

`5–50 Blöcke`

Unterirdische Bewegungen können besondere Ereignisse auslösen, beispielsweise:

* Steinschlag
* Einsturz
* Monsterüberfälle
* Entdeckung von Ressourcen
* weitere unterirdische Ereignisse

## Biome

Die Welt orientiert sich grundsätzlich an Minecraft, darf aber um zusätzliche eigene Biome erweitert werden.

Biome besitzen eigene Eigenschaften und beeinflussen unter anderem:

* Umgebung
* Wetter
* Oberflächenblöcke
* Untergrund
* Ressourcen
* Monster
* Reiseereignisse
* Kampfumgebung

Es soll gewöhnliche, ungewöhnliche und seltene Biome geben.

## Untergrund

Die Oberflächenbiome bestimmen gemeinsam mit der erreichten Y-Koordinate den Untergrund.

Geplante Bereiche:

* Oberflächenwelt
* Tropfsteinhöhlen
* Tiefes Dunkel

Die genauen Y-Grenzen werden während der technischen Umsetzung festgelegt.

## Wetter

Das Wetter besteht aus globalen und biomeabhängigen Eigenschaften.

Das Wetter dient nicht ausschließlich der Atmosphäre, sondern beeinflusst auch das Gameplay und insbesondere Kämpfe.

Beispiele:

* Nebel kann die Sicht und Trefferwahrscheinlichkeit beeinflussen.
* Regen kann bestimmte Fähigkeiten verändern.
* Gewitter kann besondere Ereignisse verursachen.

Das Wetter soll daher Bestandteil der Kampfumgebung sein.

## Kampfsystem

Die Kämpfe sind rundenbasiert.

Monster sollen nicht immer dieselbe Stärke besitzen.

Die Stärke eines Gegners kann abhängig sein von Faktoren wie:

* Monsterart
* Spieler
* Biom
* Umgebung
* Wetter
* Tageszeit
* weiteren später definierten Faktoren

## Datenverwaltung

Das Projekt verwendet überwiegend dateibasierte Daten.

Geplante Datenbanken:

* `biome.db`
* `blocks.db`
* `items.db`
* `weapons.db`
* `skills.db`
* `monsters.db`
* `crafting.db`
* weitere Datenbanken nach Bedarf

Spielerdaten werden über individuelle Dateien gespeichert.

Der Zugriff auf Daten soll möglichst einheitlich über mIRC-Funktionen wie `$readini` erfolgen.

## Entwicklung

Das Projekt wird schrittweise entwickelt.

Grundregel:

> Erst eine Funktion vollständig und nachvollziehbar umsetzen und testen, danach das nächste System beginnen.

Das Projekt soll aus klar getrennten Modulen bestehen, damit einzelne Systeme unabhängig voneinander verstanden, getestet und erweitert werden können.

## Dokumentation

Technische Entscheidungen werden in dieser Datei festgehalten.

Änderungen an grundlegenden Spielmechaniken werden dokumentiert, bevor sie dauerhaft in das Projekt übernommen werden.
