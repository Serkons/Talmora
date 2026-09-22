alias mc.world.tick {
  var %turn $mc.world.turn

  inc %turn 1

  if (%turn > 24) {
    var %turn 1

    var %day $mc.world.day
    inc %day 1

    writeini $mcdbfile(minecraft_world.db) World Day %day

  }

  if (%turn >= 1) && (%turn <= 4) {
    var %timeofday Morning
  }
  elseif (%turn >= 5) && (%turn <= 12) {
    var %timeofday Day
  }
  elseif (%turn >= 13) && (%turn <= 16) {
    var %timeofday Evening
  }
  elseif (%turn >= 17) && (%turn <= 24) {
    var %timeofday Night
  }

  writeini $mcdbfile(minecraft_world.db) World WorldTurn %turn
  writeini $mcdbfile(minecraft_world.db) World TimeOfDay %timeofday
  var %moonphase $mc.world.moonphase
  writeini $mcdbfile(minecraft_world.db) World MoonPhase %moonphase

  echo -ag MC WORLD TICK DEBUG: Day $mc.world.day - Turn %turn - TimeOfDay %timeofday
  echo -ag MC WORLD TICK DEBUG: Day $mc.world.day - Turn %turn - TimeOfDay %timeofday - MoonPhase %moonphase
}

alias mc.world.moonphase {
  var %day $mc.world.day
  var %cycle $calc((%day - 1) % 16 + 1)

  if (%cycle <= 2) { return NewMoon }
  elseif (%cycle <= 4) { return WaxingCrescent }
  elseif (%cycle <= 6) { return FirstQuarter }
  elseif (%cycle <= 8) { return WaxingGibbous }
  elseif (%cycle <= 10) { return FullMoon }
  elseif (%cycle <= 12) { return WaningGibbous }
  elseif (%cycle <= 14) { return LastQuarter }
  else { return WaningCrescent }
}
