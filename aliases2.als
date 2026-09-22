mc.event {
  ; $1 = player

  ; Overworld events only outside of battles
  if (%mc.battle == off) || (%battleis == on) { return }
  if ($1 = $null) { return }

  var -s %biome $readini($char($1), Minecraft, Biome)
  if (%biome = $null) { return }

  var -s %mc.rand.eventchance $rand(1,100)
  var -s %number.of.mc.events $readini($mcdbfile(mc_events.db), %biome, NumberOfEvents)
  if ((%number.of.mc.events = $null) || (%number.of.mc.events <= 0)) {
    return
  }

  var -s %random.mc.event.number $rand(1,%number.of.mc.events)
  var -s %event.chance $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ chance)

  if (%event.chance = $null) { return }

  if (%mc.rand.eventchance > %event.chance) {
    echo -ag MC EVENT DEBUG: Event findet nicht statt!
    return
  }

  ; Event type
  var -s %damagetype $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ type)

  if (%damagetype = $null) { return }

  ;; Event Type Heilung

  if (%damagetype == heal) {

    ; Heilungswert aus dem Event lesen
    var %heal.amount $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ Amount)

    if (%heal.amount = $null) {
      echo -ag MC EVENT ERROR: Heal Event ohne Amount!
      return
    }

    ; Aktuelle und maximale HP
    var %current.hp $readini($char($1), Battle, HP)
    var %max.hp $readini($char($1), BaseStats, HP)

    ; Heilung anwenden
    var %new.hp $calc(%current.hp + %heal.amount)

    ; Nicht über MaxHP heilen
    if (%new.hp > %max.hp) {
      var %new.hp %max.hp
    }

    ; Tatsächlich geheilte HP berechnen
    var %healed.hp $calc(%new.hp - %current.hp)

    writeini $char($1) Battle HP %new.hp

    ; Eventbeschreibung
    var %eventmess $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ desc)

    if (%eventmess != $null) {
      $display.mc.message(%eventmess,event,channel)
    }

    if (%healed.hp <= 0) {
      var %heal.mess Deine Wunden sind bereits vollständig verheilt. Du hast 07 $+ %new.hp $+ / $+ %max.hp  HP.
    }
    else {
      var %heal.mess Durch das Ereignis wirst du um 03 $+ %healed.hp  HP geheilt. Du hast nun 07 $+ %new.hp $+ / $+ %max.hp  HP.
    }

    $display.mc.message(%heal.mess,event,channel)

    return
  }

  if (%damagetype == damage) {
    set %who.battle $1
    set %attack.damage $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ Amount)
    if (%attack.damage = $null) {
      echo -ag MC EVENT ERROR: Damage Event ohne Amount!
      return
    }
    echo -ag Schadenstype ist %damagetype
    echo -ag Schadenswert ist %attack.damage
    var %targethp $readini($char(%who.battle), Battle, HP)
    if (%targethp <= 0) { return }

    if (%attack.damage <= 0) {
      set %attack.damage 1
    }

    if ($readini($char(%who.battle), info, IgnoreBattlefieldDamage) = true) {
      set %attack.damage 0
    }

    var %mess 2====7 Minecraft Event: 4Damage2====
    var %eventmess $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ desc)

    $display.message(%mess, battle)
    $display.message(%eventmess, battle)

    $deal_damage(battlefield, %who.battle, battlefield)
    var %currenthp $readini($char($1),Battle,HP) 
    var -s %damage.mess Durch das Ereignis erleidest du 04 $+ %attack.damage  Schaden. Dir bleiben noch 07 $+ %currenthp  HP.
    $display.mc.message(%damage.mess,event,channel)

    if (%currenthp <= 0) { $display.mc.message($1 Starb an einem Ereigniss unbekannter herkunft xD,event,channel)  }

    ;$display_aoedamage(battlefield, %who.battle, battlefield)
  }
  if (%damagetype == status) {

    ; Eventbeschreibung anzeigen
    var %eventmess $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ desc)

    if (%eventmess != $null) {
      $display.mc.message(%eventmess,event,channel)
    }

    ; Status aus mc_events.db lesen
    var -s %statustype $readini($mcdbfile(mc_events.db), %biome, event $+ %random.mc.event.number $+ StatusType)

    ; Erlaubte negative StatusEffects
    var %negative.status.list poison.HeavyPoison.burning.freezing.frozen.shock.Blind.Petrified.bored.intimidate.terrify.paralysis.sleep.stun.stop.curse.zombie

    if (%statustype = $null) { return }

    ; Unbekannten Status niemals schreiben
    if ($istok(%negative.status.list,%statustype,46) == $false) {
      echo -ag MC EVENT DEBUG: Unbekannter StatusEffect: %statustype
      return
    }

    ; Poison besitzt unsere Staffelungslogik
    if (%statustype == poison) {

      ; Merken, ob vor diesem Event bereits eine Vergiftung aktiv war
      var %poison.was.active $false

      if (($readini($char($1), Status, Poison) == yes) || ($readini($char($1), Status, HeavyPoison) == yes)) {
        var %poison.was.active $true
      }

      ; Poison anwenden bzw. vorhandenes Poison eskalieren
      $mc.poison.apply($1)

      ; Nur die ERSTE Vergiftung verursacht sofort ihren ersten Tick
      if (%poison.was.active == $false) {
        var %poison.result $mc.poison.check($1)

        if (%poison.result == dead) {
          return
        }
      }

      echo -ag MC EVENT DEBUG: Poison Event wurde auf $1 angewendet.
      return
    }

    ; Alle anderen gültigen negativen Status direkt setzen
    writeini $char($1) Status %statustype yes

    echo -ag MC EVENT DEBUG: StatusEffect %statustype wurde bei $1 gesetzt.
  }

  if ($readini($char(%who.battle), Battle, HP) <= 0) {
    $mc.respawn(%who.battle)
  }
  unset %attack.damage
}

mc.status.check {
  ; $1 = player

  if ($1 = $null) { return }

  var %status.result $mc.poison.check($1)

  if (%status.result == dead) {
    return dead
  }
}

mc.poison.apply {
  ; $1 = player

  if ($1 = $null) { return }

  ; HeavyPoison ist bereits aktiv
  if ($readini($char($1), Status, HeavyPoison) = yes) {
    echo -ag MC POISON DEBUG: $1 ist bereits schwer vergiftet.
    return
  }

  ; Normales Poison ist bereits aktiv -> zu HeavyPoison steigern
  if ($readini($char($1), Status, Poison) = yes) {
    writeini $char($1) Status Poison no
    writeini $char($1) Status HeavyPoison yes

    echo -ag MC POISON DEBUG: $1 wurde schwer vergiftet!
    return
  }

  ; Spieler war noch gar nicht vergiftet
  writeini $char($1) Status Poison yes
  writeini $char($1) Status HeavyPoison no
  writeini $char($1) Status Poison.Timer 0

  echo -ag MC POISON DEBUG: $1 wurde vergiftet!
}

mc.biome.is.mountain {
  ; $1 = biome

  if ($1 = $null) { return $false }

  var -s %mountain $readini($mcdbfile(Biomes.db), $1, IsMountain)

  if (%mountain == true) {
    return $true
  }

  return $false
}
