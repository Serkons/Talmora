on *:text:!move:#: {

  ; Aktive Oberwelt-StatusEffects verarbeiten
  var %status.result $mc.status.check($nick)

  if (%status.result == dead) {
    echo -ag MC MOVE DEBUG: Bewegung abgebrochen - Spieler ist durch einen StatusEffect gestorben.
    return
  }

  ; Oberfläche
  if ($mc.is.surface($nick) = $true) {

    var %biome $readini($char($nick), Minecraft, Biome)

    if ($mc.biome.is.mountain(%biome) = $true) {
      echo -ag MC MOVE DEBUG: Normale Bewegung blockiert - Mountain-Biom: %biome
      msg %battlechan Das Gelände vor dir ist zu steil für eine normale Bewegung. Benutze !hike, um deinen Weg fortzusetzen.
      return
    }

    /mc.move.overworld $nick move
    /mc.event $nick
    return
  }

  ; Untergrund
  if ($mc.is.surface($nick) = $false) {
    echo -ag MC MOVE DEBUG: Spieler befindet sich unter der Oberfläche.
    return
  }

  if (%mc.encounter.roll <= 25) {
    echo -ag MC MOVE DEBUG: Encounter ausgelöst! Roll: %mc.encounter.roll
    set %mc.encounter.player $nick
    /startnormal monster

    /.timerMCAutoEnter 1 1 /mc.battle.autoenter %mc.encounter.player
  }
  else {
    echo -ag MC MOVE DEBUG: Kein Encounter. Roll: %mc.encounter.roll
    return
  }
}

on *:text:!sprint:#: {

  ; Aktive Oberwelt-StatusEffects verarbeiten
  var %status.result $mc.status.check($nick)

  if (%status.result == dead) {
    echo -ag MC SPRINT DEBUG: Sprint abgebrochen - Spieler ist durch einen StatusEffect gestorben.
    return
  }

  ; Oberfläche
  if ($mc.is.surface($nick) = $true) {

    var %biome $readini($char($nick), Minecraft, Biome)

    if ($mc.biome.is.mountain(%biome) = $true) {
      echo -ag MC SPRINT DEBUG: Sprint blockiert - Mountain-Biom: %biome
      msg %battlechan Das Gelände vor dir ist zu steil zum Sprinten. Benutze !hike, um deinen Weg fortzusetzen.
      return
    }

    /mc.move.overworld $nick sprint
    /mc.event $nick
    return
  }

  ; Untergrund
  if ($mc.is.surface($nick) = $false) {
    echo -ag MC SPRINT DEBUG: Spieler befindet sich unter der Oberfläche.
    return
  }

  if (%mc.encounter.roll <= 25) {
    echo -ag MC SPRINT DEBUG: Encounter ausgelöst! Roll: %mc.encounter.roll
    set %mc.encounter.player $nick
    /startnormal monster

    /.timerMCAutoEnter 1 1 /mc.battle.autoenter %mc.encounter.player
  }
  else {
    echo -ag MC SPRINT DEBUG: Kein Encounter. Roll: %mc.encounter.roll
    return
  }
}

alias mc.is.surface {
  ; $1 = player

  if ($1 = $null) { return $false }

  var -s %y = $readini($char($1), Minecraft, Y)
  var -s %surface.y = $mc.surface.y($1)

  if ((%y = $null) || (%surface.y = $null)) {
    return $false
  }

  if (%y == %surface.y) {
    return $true
  }

  return $false
}

alias mc.surface.y {
  ; $1 = player

  if ($1 = $null) { return }

  return $readini($char($1), Minecraft, SurfaceY)
}

alias display.biome { return 3 $+ $1 $+  }

on *:text:!hike:#: {
  /mc.hike $nick
}
