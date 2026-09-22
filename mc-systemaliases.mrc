alias mc.spawn {
  ; $1 = player

  ; -----------------------------------------
  ; 1. Alle SafeSpawn-Biome aus biomes.db sammeln
  ; -----------------------------------------
  var %biome.count $ini($mcdbfile(biomes.db), 0)
  var %biome.index 1
  var %safe.biomes

  while (%biome.index <= %biome.count) {

    var %biome.id $ini($mcdbfile(biomes.db), %biome.index)
    var %safe.spawn $readini($mcdbfile(biomes.db), %biome.id, SafeSpawn)
    echo -ag MC SPAWN DEBUG: Prüfe %biome.id - SafeSpawn: %safe.spawn

    if (%safe.spawn = true) {
      %safe.biomes = $addtok(%safe.biomes,%biome.id,46)
    }

    inc %biome.index
  }

  ; Falls kein SafeSpawn-Biome gefunden wurde
  if (%safe.biomes = $null) {
    echo -ag MC SPAWN ERROR: Keine SafeSpawn-Biome in biomes.db gefunden.
    return
  }

  ; -----------------------------------------
  ; 2. Zufälliges SafeSpawn-Biome auswählen
  ; -----------------------------------------
  var %safe.count $numtok(%safe.biomes,46)
  var %random.biome $gettok(%safe.biomes,$rand(1,%safe.count),46)

  ; -----------------------------------------
  ; 3. Y-Bereich aus dem ausgewählten Biome lesen
  ; -----------------------------------------
  var %surface.min.y $readini($mcdbfile(biomes.db), %random.biome, SurfaceMinY)
  var %surface.max.y $readini($mcdbfile(biomes.db), %random.biome, SurfaceMaxY)

  ; Sicherheit für fehlerhafte DB-Einträge
  if ((%surface.min.y = $null) || (%surface.max.y = $null)) {
    echo -ag MC SPAWN ERROR: SurfaceMinY/SurfaceMaxY fehlt bei %random.biome
    return
  }

  ; -----------------------------------------
  ; 4. Spawnkoordinaten bestimmen
  ; -----------------------------------------
  var %spawn.x $rand(-10000,10000)
  var %spawn.y $rand(%surface.min.y,%surface.max.y)
  var %spawn.z $rand(-10000,10000)

  echo -ag MC SPAWN DEBUG: SafeSpawn-Liste: %safe.biomes
  echo -ag MC SPAWN DEBUG: Ausgewählt: %random.biome
  echo -ag MC SPAWN DEBUG: SurfaceY: %surface.min.y - %surface.max.y
  echo -ag MC SPAWN DEBUG: Spawn: X %spawn.x Y %spawn.y Z %spawn.z

  ; -----------------------------------------
  ; 5. Minecraft-Spielerdaten schreiben
  ; -----------------------------------------
  writeini $char($1) Minecraft Dimension Overworld
  writeini $char($1) Minecraft Biome %random.biome

  writeini $char($1) Minecraft X %spawn.x
  writeini $char($1) Minecraft Y %spawn.y
  writeini $char($1) Minecraft Z %spawn.z

  writeini $char($1) Minecraft SpawnX %spawn.x
  writeini $char($1) Minecraft SpawnY %spawn.y
  writeini $char($1) Minecraft SpawnZ %spawn.z
  writeini $char($1) Minecraft SpawnBiome %random.biome
}

alias mc.move.test {
  ; $1 = player
  ; Reine Simulation - schreibt KEINE Daten

  ; -----------------------------------------
  ; 1. Zufälliges Biome aus biomes.db wählen
  ; -----------------------------------------
  var %biome.count $ini($mcdbfile(biomes.db), 0)

  if (%biome.count <= 0) {
    echo -ag Minecraft MOVE TEST: biomes.db ist leer oder nicht vorhanden.
    return
  }

  var %biome.id $ini($mcdbfile(biomes.db), $rand(1,%biome.count))
  var %biome.name $readini($mcdbfile(biomes.db), %biome.id, Name)

  if (%biome.name = $null) { var %biome.name %biome.id }


  ; -----------------------------------------
  ; 2. Bewegung simulieren
  ; -----------------------------------------
  var %direction.roll $rand(1,4)
  var %distance $rand(30,500)

  if (%direction.roll = 1) { var %direction North }
  if (%direction.roll = 2) { var %direction South }
  if (%direction.roll = 3) { var %direction East }
  if (%direction.roll = 4) { var %direction West }

  ; Aktuelle Werte nur lesen.
  ; Falls leer, für den Test 0 benutzen.
  var %old.x $readini($char($1), Minecraft, X)
  var %old.y $readini($char($1), Minecraft, Y)
  var %old.z $readini($char($1), Minecraft, Z)

  if (%old.x = $null) { var %old.x 0 }
  if (%old.y = $null) { var %old.y 70 }
  if (%old.z = $null) { var %old.z 0 }

  var %new.x %old.x
  var %new.y %old.y
  var %new.z %old.z

  if (%direction = North) { dec %new.z %distance }
  if (%direction = South) { inc %new.z %distance }
  if (%direction = East)  { inc %new.x %distance }
  if (%direction = West)  { dec %new.x %distance }


  ; -----------------------------------------
  ; 3. Tageszeit simulieren
  ; -----------------------------------------
  var %timeofday.list Morning.Noon.Evening.Night
  var %timeofday $gettok(%timeofday.list,$rand(1,$numtok(%timeofday.list,46)),46)


  ; -----------------------------------------
  ; 4. Wetter aus dem Biome simulieren
  ; -----------------------------------------
  var %weather.list $readini($mcdbfile(biomes.db), %biome.id, Weather)

  if (%weather.list = $null) {
    var %weather Clear
  }
  else {
    var %weather $gettok(%weather.list,$rand(1,$numtok(%weather.list,46)),46)
  }


  ; -----------------------------------------
  ; 5. Animal oder Hostile Encounter simulieren
  ; -----------------------------------------
  var %encounter.type $rand(1,2)

  if (%encounter.type = 1) {
    var %encounter.list $readini($mcdbfile(biomes.db), %biome.id, Animals)
    var %encounter.category Animal
  }

  if (%encounter.type = 2) {
    var %encounter.list $readini($mcdbfile(biomes.db), %biome.id, HostileMobs)
    var %encounter.category Hostile
  }

  if (%encounter.list != $null) {
    var %encounter $gettok(%encounter.list,$rand(1,$numtok(%encounter.list,46)),46)
    set %mc.encounter.monster %encounter
    set %mc.encounter.level 1
    set %mc.battle on
  }
  else {
    var %encounter None
  }


  ; -----------------------------------------
  ; 6. Passende Beschreibung ermitteln
  ;
  ; Beispiel:
  ; Morning + Rain
  ; -> DescMorningRain
  ; -----------------------------------------
  var %desc.key Desc $+ %timeofday $+ %weather
  var %desc.file $readini($mcdbfile(biomes.db), %biome.id, %desc.key)

  if ((%desc.file != $null) && ($isfile($mclstfile(%desc.file)) = $true)) {
    var %description $read($mclstfile(%desc.file))
  }
  else {
    var %description Keine Beschreibung für %desc.key gefunden.
  }

  set %mc.encounter.player $1

  ; -----------------------------------------
  ; 7. TESTAUSGABE
  ; -----------------------------------------
  echo -ag --------------------------------------------------
  echo -ag MINECRAFT !MOVE SIMULATION
  echo -ag Spieler: $1
  echo -ag Biome: %biome.name
  echo -ag Richtung: %direction
  echo -ag Distanz: %distance Blöcke
  echo -ag Alte Position: X %old.x  Y %old.y  Z %old.z
  echo -ag Simulierte Position: X %new.x Y %new.y  Z %new.z
  echo -ag Tageszeit: %timeofday
  echo -ag Wetter: %weather
  echo -ag Encounter-Typ: %encounter.category
  echo -ag Encounter: %encounter
  echo -ag Beschreibung: %description
  echo -ag --------------------------------------------------
}

alias checkcount {
  var %maxtimers $timer(0)
  var %number.of.players $readini($txtfile(battle2.txt), battleinfo, players)
  while (%maxtimers >= 0) {
    if ($timer(%maxtimers)name == battlebegin) {
      if ($timer(%maxtimers).secs == 30) { msg %battlechan 4,1ATTENTION!!14,1 Time left to join the battle are 8 $timer(%maxtimers).secs  14,1 sec }
      if ($timer(%maxtimers).secs == 20) { msg %battlechan 4,1ATTENTION!!14,1 Time left to join the battle are 8 $timer(%maxtimers).secs  14,1 sec }
      if ($timer(%maxtimers).secs == 10) { msg %battlechan 4,1ATTENTION!!14,1 Time left to join the battle are 8 $timer(%maxtimers).secs  14,1 sec }
      if ($timer(%maxtimers).secs == 5) { msg %battlechan 4,1ATTENTION!!14,1 Time left to join the battle are 8 $timer(%maxtimers).secs  14,1 sec }
      if (%number.of.players >= 1) && (%battle.type != ai) {
        if ($timer(%maxtimers).secs == 1) { msg %battlechan 4,1BATTLESTART14,1 Generating.... Monsters,Weather,Battlefields etc.... }
      }
    }
    dec %maxtimers
  }
}

alias encounter.level {

  return %mc.encounter.level

}

alias mc.test.battle {
  set %mc.battle on
  set %mc.encounter.monster Zombie
  set %mc.encounter.level 5

  echo -ag Minecraft Battle Test vorbereitet:
  echo -ag Monster: %mc.encounter.monster
  echo -ag Level: %mc.encounter.level
}

alias mc.respawn {
  ; $1 = player

  ; Spawn-Daten laden
  var %spawn.x $readini($char($1), Minecraft, SpawnX)
  var %spawn.y $readini($char($1), Minecraft, SpawnY)
  var %spawn.z $readini($char($1), Minecraft, SpawnZ)
  var %spawn.biome $readini($char($1), Minecraft, SpawnBiome)

  ; Aktuelle Position auf Spawn zurücksetzen
  writeini $char($1) Minecraft Dimension Overworld
  writeini $char($1) Minecraft Biome %spawn.biome
  writeini $char($1) Minecraft SurfaceY %spawn.y
  writeini $char($1) Minecraft X %spawn.x
  writeini $char($1) Minecraft Y %spawn.y
  writeini $char($1) Minecraft Z %spawn.z

  ; Alle Statuszustände entfernen
  $clear_status($1)

  ; Spieler wiederbeleben
  var %max.hp $readini($char($1), BaseStats, HP)
  var %respawn.hp $round($calc(%max.hp * 0.50),0)

  if (%respawn.hp < 1) { var %respawn.hp 1 }

  writeini $char($1) Battle HP %respawn.hp
  writeini $char($1) Battle Status alive

  ; Respawn-Meldung
  $display.message(3 $+ $1  erwacht wieder in der Welt..., global)
  $display.message(3Du öffnest langsam die Augen und findest dich an deinem ursprünglichen Spawnpunkt wieder., global)
  $display.message(10Biome: %spawn.biome 10 Position: X %spawn.x Y %spawn.y Z %spawn.z, global)
  $display.message(4Du kehrst mit %respawn.hp / %max.hp HP zurück., global)
}

alias mc.battle.autoenter {
  ; $1 = player

  if (%mc.battle != on) { return }
  if ($1 = $null) { return }

  $enter($1)

  ; Minecraft battle starts shortly after auto-enter
  /.timerMCBattleBegin 1 1 /battlebegin

}

alias mc.region.x {
  return $floor($calc($1 / $mc.region.size))
}

alias mc.region.z {
  return $floor($calc($1 / $mc.region.size))
}

alias mc.regiontest {

  var %old.x 3915
  var %old.z -1414

  var %new.x 3990
  var %new.z -1500

  var %old.rx $mc.region.x(%old.x)
  var %old.rz $mc.region.z(%old.z)

  var %new.rx $mc.region.x(%new.x)
  var %new.rz $mc.region.z(%new.z)

  echo -ag MC REGION DEBUG: Alt= %old.rx $+ , $+ %old.rz Neu= %new.rx $+ , $+ %new.rz

  if ((%old.rx != %new.rx) || (%old.rz != %new.rz)) {
    echo -ag MC REGION DEBUG: Regionsgrenze überschritten!
  }
  else {
    echo -ag MC REGION DEBUG: Spieler bleibt in derselben Region.
  }
}

alias mc.regiontest500 {

  var %old.x 3915
  var %old.z -1414

  var %new.x 4348
  var %new.z -1414

  var %old.rx $mc.region.x(%old.x)
  var %old.rz $mc.region.z(%old.z)

  var %new.rx $mc.region.x(%new.x)
  var %new.rz $mc.region.z(%new.z)

  echo -ag MC REGION 500 DEBUG: Alt= %old.rx $+ , $+ %old.rz Neu= %new.rx $+ , $+ %new.rz

  if ((%old.rx != %new.rx) || (%old.rz != %new.rz)) {
    echo -ag MC REGION 500 DEBUG: Regionsgrenze überschritten!
  }
  else {
    echo -ag MC REGION 500 DEBUG: Spieler bleibt in derselben Region.
  }
}

alias mc.move.overworld {
  ; $1 = player
  ; $2 = movement type: move / sprint

  if ($1 = $null) { return }

  ; Aktuelle Position lesen
  var %old.x $readini($char($1), Minecraft, X)
  var %old.z $readini($char($1), Minecraft, Z)
  var -s %old.biome $readini($char($1), Minecraft, Biome)

  ; Richtung bestimmen
  var %direction $rand(1,4)

  ; Distanz anhand der Bewegungsart bestimmen
  if ($2 == move) {
    var %distance $rand(5,50)
  }
  elseif ($2 == sprint) {
    var %distance $rand(30,500)
  }
  else {
    echo -ag MC MOVE ERROR: Unbekannte Bewegungsart: $2
    return
  }

  ; Zielposition beginnt bei aktueller Position
  var %new.x %old.x
  var %new.z %old.z

  ; 1 = Norden / 2 = Osten / 3 = Süden / 4 = Westen
  if (%direction = 1) {
    dec %new.z %distance
    var %direction.name Norden
  }
  elseif (%direction = 2) {
    inc %new.x %distance
    var %direction.name Osten
  }
  elseif (%direction = 3) {
    inc %new.z %distance
    var %direction.name Süden
  }
  elseif (%direction = 4) {
    dec %new.x %distance
    var %direction.name Westen
  }

  ; Alte Region bestimmen
  var %old.rx $mc.region.x(%old.x)
  var %old.rz $mc.region.z(%old.z)

  ; Neue Region bestimmen
  var %new.rx $mc.region.x(%new.x)
  var %new.rz $mc.region.z(%new.z)

  echo -ag MC MOVE TEST: Spieler: $1
  echo -ag MC MOVE TEST: Bewegungsart: $2
  echo -ag MC MOVE TEST: Richtung: %direction.name
  echo -ag MC MOVE TEST: Distanz: %distance Blöcke
  echo -ag MC MOVE TEST: Alt: X %old.x Z %old.z
  echo -ag MC MOVE TEST: Neu: X %new.x Z %new.z
  echo -ag MC MOVE TEST: Alte Region: %old.rx $+ , $+ %old.rz
  echo -ag MC MOVE TEST: Neue Region: %new.rx $+ , $+ %new.rz

  ; Sichtbare Reiseinformation
  var %mc.travel.text $read($mclstfile(mc_move_travel.lst))
  msg %battlechan %mc.travel.text

  if ((%old.rx != %new.rx) || (%old.rz != %new.rz)) {
    echo -ag MC MOVE TEST: Regionsgrenze überschritten!

    if ($mc.region.exists(%new.rx,%new.rz) = $true) {
      var %new.biome $mc.region.biome(%new.rx,%new.rz)

      echo -ag MC WORLD DEBUG: Region existiert bereits.
      echo -ag MC WORLD DEBUG: Biome: %new.biome
    }
    else {
      echo -ag MC WORLD DEBUG: Unbekannte Region - wird erzeugt!

      /mc.region.create %new.rx %new.rz

      var -s %new.biome $mc.region.biome(%new.rx,%new.rz)

      echo -ag MC WORLD DEBUG: Neues Biome: %new.biome
    }

    ; Echten Biomwechsel prüfen
    if (%old.biome != %new.biome) {
      echo -ag MC BIOME DEBUG: Echter Biomwechsel: %old.biome -> %new.biome

      var %mc.move.text $read($mclstfile(mc_move_newbiome.lst))
      msg %battlechan %mc.move.text
      msg %battlechan Du hast das Biom $display.biome(%new.biome) erreicht.
    }
    else {
      echo -ag MC BIOME DEBUG: Region gewechselt, Biom bleibt %new.biome

      var %mc.move.text $read($mclstfile(mc_move_samebiome.lst))
      msg %battlechan %mc.move.text
    }

    writeini $char($1) Minecraft Biome %new.biome
  }
  else {
    echo -ag MC MOVE TEST: Spieler bleibt in derselben Region.

    var %mc.move.text $read($mclstfile(mc_move_samebiome.lst))
    msg %battlechan %mc.move.text
  }

  ; Neue Position dauerhaft speichern
  writeini $char($1) Minecraft X %new.x
  writeini $char($1) Minecraft Z %new.z
}

alias mc.region.section {
  ; $1 = RegionX
  ; $2 = RegionZ

  return Region_ $+ $1 $+ _ $+ $2
}

alias mc.region.exists {
  ; $1 = RegionX
  ; $2 = RegionZ

  var -s %section $mc.region.section($1,$2)

  if ($ini($mcdbfile(minecraft_world.db), %section) != $null) {
    return $true
  }

  return $false
}

alias mc.region.biome {
  ; $1 = RegionX
  ; $2 = RegionZ

  var %section $mc.region.section($1,$2)
  return $readini($mcdbfile(minecraft_world.db), %section, Biome)
}

alias mc.region.random.biome {
  var %biome.count $ini($mcdbfile(biomes.db), 0)
  var %biome.index 1
  var %biome.list

  while (%biome.index <= %biome.count) {
    var %biome $ini($mcdbfile(biomes.db), %biome.index)

    ; Nur Overworld-Biome für normale Oberflächenregionen
    if (($readini($mcdbfile(biomes.db), %biome, Dimension) = Overworld) && ($readini($mcdbfile(biomes.db), %biome, SafeSpawn) = true)) {
      %biome.list = $addtok(%biome.list,%biome,46)
    }

    inc %biome.index
  }

  if (%biome.list = $null) { return }

  return $gettok(%biome.list,$rand(1,$numtok(%biome.list,46)),46)
}

alias mc.region.create {
  ; $1 = RegionX
  ; $2 = RegionZ

  var %section $mc.region.section($1,$2)
  var %biome $mc.region.random.biome

  if (%biome = $null) { return }

  writeini $mcdbfile(minecraft_world.db) %section Biome %biome

  echo -ag MC REGION DEBUG: Neue Region %section erzeugt - Biome: %biome
}

alias mc.region.size {
  return 500
}

alias mc.world.timeofday {
  return $readini($mcdbfile(minecraft_world.db), World, TimeOfDay)
}

alias mc.world.turn {
  return $readini($mcdbfile(minecraft_world.db), World, WorldTurn)
}
alias mc.world.day {
  return $readini($mcdbfile(minecraft_world.db), World, Day)
}

alias display.mc.message {
  ;$1 = Text
  ;$2 = type
  ;$3 = ziel

  var %text = $1
  if ($2 == move) { var %text 05[BEWEGUNG] $1  }
  if ($2 == event) { var %text 03[EVENT] $1  }
  if ($3 == channel) { msg %battlechan %text }
  if ($3 == private) { msg $nick %text }



}
on *:text:!displaytestbiome:#: { $display.mc.message(Wärend deiner bewegung hast du das biome $display.biome(IrgendeinBiome) entdeckt,move,channel) }

alias mc.poison.check {
  ; $1 = player

  if ($1 = $null) { return }

  if (($readini($char($1), Status, Poison) != yes) && ($readini($char($1), Status, HeavyPoison) != yes)) {
    return
  }

  var %poison.timer $readini($char($1), status, poison.timer)

  if (%poison.timer = $null) {
    var %poison.timer 0
  }

  ; Minecraft Overworld: Poison hält 3 Bewegungs-Turns
  var %poison.max.turns 3

  ; Ist die Vergiftung abgelaufen?
  if (%poison.timer >= %poison.max.turns) {
    writeini $char($1) Status Poison no
    writeini $char($1) Status HeavyPoison no
    writeini $char($1) Status Poison.Timer 0

    echo -ag MC POISON DEBUG: Gift bei $1 ist abgeklungen.
    return
  }

  ; Poison-Turn erhöhen
  inc %poison.timer 1
  writeini $char($1) status poison.timer %poison.timer

  ; 20% der maximalen HP wie beim Core
  var %max.hp $readini($char($1), BaseStats, HP)

  if ($readini($char($1), Status, HeavyPoison) = yes) {
    var %poison.damage $round($calc(%max.hp * .25),0)
  }
  else {
    var %poison.damage $round($calc(%max.hp * .20),0)
  }

  set %attack.damage %poison.damage

  echo -ag MC POISON DEBUG: $1 - Tick %poison.timer - Damage %poison.damage

  ; Core übernimmt die saubere Schadensabwicklung
  $deal_damage(poison,$1,poison)

  ; Minecraft-spezifische Poison-Schadensmeldung
  var %current.hp $readini($char($1), Battle, HP)

  if ($readini($char($1), Status, HeavyPoison) == yes) {
    var %poison.message Durch die schwere Vergiftung erleidest du 04 $+ %poison.damage  Schaden. Dir bleiben noch 07 $+ %current.hp  HP.
  }
  else {
    var %poison.message Durch die Vergiftung erleidest du 04 $+ %poison.damage  Schaden. Dir bleiben noch 07 $+ %current.hp  HP.
  }

  $display.mc.message(%poison.message,event,channel)


  ; Sichtbare Schadensmeldung erstmal Core-seitig
  ;$display_aoedamage(poison,$1,poison)

  ; Falls Poison tödlich war
  if ($readini($char($1), Battle, HP) <= 0) {
    $display.mc.message($1 konnte das Gift nicht bezwingen und starb!,event,channel)
    $mc.respawn($1)
    return dead
  }

  unset %attack.damage
}

alias mc.hike {
  ; $1 = player

  if ($1 = $null) { return }

  var %biome $readini($char($1), Minecraft, Biome)

  ; Nur in Gebirgsbiomen
  if ($mc.biome.is.mountain(%biome) = $false) {
    msg %battlechan Hier brauchst du nicht zu klettern. Benutze !move.
    return
  }

  ; Nicht unterirdisch hiken
  if ($mc.is.surface($1) = $false) {
    msg %battlechan Du kannst unter der Erde nicht !hike benutzen.
    return
  }

  var %x $readini($char($1), Minecraft, X)
  var %y $readini($char($1), Minecraft, Y)
  var %z $readini($char($1), Minecraft, Z)

  var %max.y $readini($mcdbfile(biomes.db), %biome, SurfaceMaxY)

  ; Kleine horizontale Gebirgsbewegung
  var %distance $rand(5,10)
  var %direction $rand(1,4)

  if (%direction == 1) {
    dec %z %distance
    var %direction.name Norden
  }
  elseif (%direction == 2) {
    inc %z %distance
    var %direction.name Süden
  }
  elseif (%direction == 3) {
    inc %x %distance
    var %direction.name Osten
  }
  elseif (%direction == 4) {
    dec %x %distance
    var %direction.name Westen
  }

  ; Gelände bestimmen
  var %terrain.roll $rand(1,100)

  ; Spieler befindet sich bereits auf der maximalen Höhe
  if (%y >= %max.y) {

    ; 50% ebener Weg
    if (%terrain.roll <= 50) {
      var %y.change 0
    }
    else {
      var %y.change $calc(0 - $rand(1,2))
    }
  }

  ; Spieler befindet sich unterhalb der maximalen Höhe
  else {

    if (%terrain.roll <= 60) {
      var %y.change $rand(1,3)
    }
    elseif (%terrain.roll <= 80) {
      var %y.change 0
    }
    else {
      var %y.change $calc(0 - $rand(1,2))
    }
  }

  var %new.y $calc(%y + %y.change)

  ; Bergspitze niemals überschreiten
  if (%new.y > %max.y) {
    var %new.y %max.y
  }

  ; Neue Position schreiben
  writeini $char($1) Minecraft X %x
  writeini $char($1) Minecraft Y %new.y
  writeini $char($1) Minecraft Z %z

  ; Spieler bleibt beim Hiken auf der Geländeoberfläche
  writeini $char($1) Minecraft SurfaceY %new.y

  echo -ag MC HIKE DEBUG: $1 - Biome: %biome - Richtung: %direction.name - Distanz: %distance - Y: %y -> %new.y - Roll: %terrain.roll
}
