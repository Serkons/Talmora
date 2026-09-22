on *:text:!Readfile:#: {

  set %a $read $mircdir $+ txts\armor.txt
  /msg $chan Hi: $read(armor.txt)
}

on 1:Text:rand:#: {

  var %randb $rand(1,50)
  if (%randb <= 9) { set %randa .0 $+ %randb | set %burn.type 3( 10Slight Burn 3 $+ ) }
  if (%randb >= 10) && (%randb <= 39) { set %randa . $+ %randb | set %burn.type 3( 7Medium Burn  3 $+ ) }
  if (%randb >= 40) && (%randb <= 50) { set %randa . $+ %randb | set %burn.type 3( 4Severe Burn 3 $+ ) }
  msg $chan Randomwert: %randa %burn.type
}

on *:text:monsters:#: {
  msg $chan $monsterlist
}

on *:text:weapons:#: {
  set %chan $chan
  MaxWeapons
}

Alias MaxWeapons {
  var %maxini 25
  var %x 1
  while (%x <= %maxini) {

    set $chr(37) $+ $ini($dbfile(Weapons.db),Weapons,%x) $numtok($readini($dbfile(Weapons.db),Weapons,$ini($dbfile(Weapons.db),Weapons,%x)),46)
    set %mathform $instok(%mathform, $chr(37) $+ $ini($dbfile(Weapons.db),Weapons,%x) $chr(32) +,1,32)
    inc %x
  }
  set %maxweapons $calc(%mathform)
  msg %chan $me Besitzt insgesamt %maxweapons Waffenarten.
  var %b 1
  while (%b <= %maxini) {
    set $chr(37) $+ $ini($dbfile(Weapons.db),Weapons,%b) $+ percent $round($calc($var($chr(37) $+ $ini($dbfile(Weapons.db),Weapons,%b),1).value / 100 * %maxweapons),0) $+ $chr(37)
    ;;if ($numtok(%weaponlist,46) <= 20) { var %weaponlist $instok(%weaponlist,Waffentyp: $ini($dbfile(Weapons.db),Weapons,%b) Prozentwert: $var($ini($dbfile(Weapons.db),Weapons,%b) $+ percent,1).value, 46) }
    ;;if ($numtok(%weaponlist2,46) <= 20) { var %weaponlist2 $instok(%weaponlist2,Waffentyp: $ini($dbfile(Weapons.db),Weapons,%b) Prozentwert: $var($ini($dbfile(Weapons.db),Weapons,%b) $+ percent,1).value, 46) }
    ;;msg %chan Waffenart: $ini($dbfile(Weapons.db),Weapons,%b) 08,1 $var($ini($dbfile(Weapons.db),Weapons,%b) $+ percent,1).value = $iif($var($ini($dbfile(Weapons.db),Weapons,%b),1).value <= 1, $var($ini($dbfile(Weapons.db),Weapons,%b),1).value   7Waffe, $var($ini($dbfile(Weapons.db),Weapons,%b),1).value  7Waffen))
    inc %b
  }
  echo -ag ---> %weaponlist %weaponlist2
}

alias monsterlist {
  var -s %monsters $findfile($mircdir $+ monsters\, *.char,0)
  var -s %bosses  $findfile($mircdir $+ bosses\, *.char,0)
  ;;var -s %monstername $findfile($mircdir $+ monsters\, *.char,$rand(1,%monsters))
  var -s %maxmonsters $calc(%bosses + %monsters)
  var -s %monsterpercent $round($calc(%monsters / %maxmonsters * 100),0) $+ $chr(37)
  var -s %bosspercent $round($calc(%bosses / %maxmonsters * 100),0) $+ $chr(37)
  return $me Besitzt zur zeit eine Gesamtanzahl von %maxmonsters Monstern (Inclusive Bossmonster). Davon sind 07 $+ %monsterpercent  Monster und 07 $+ %bosspercent  Bosse vorhanden 
}

on 1:text:!heal*:#: {
  set %pmd $readini(system.dat, system,PlayersMustDieMode)
  if (%battleis == on) && (%pmd == true) {
    if ($isfile($char($nick)) == $true) && ($2 == $null) {
      msg # Heilung nur auserhalb möglich.
      halt
    }
    if ($isfile($char($nick)) == $false) && ($2 == $null) {
      msg # Sry einen Nichtvorhandenen Spieler kann ich nicht helfen.
    }
    if ($isfile($char($nick)) == $true) && ($2 isnum) {
      msg # Heilung nur auserhalb möglich.
      halt
    }
    if ($isfile($char($nick)) == $false) && ($2 isnum) {
      msg # Sry einen Nichtvorhandenen Spieler kann ich nicht helfen.
    }
    if ($isfile($char($nick)) == $true) && ($2 !isnum) {
      msg # Heilung nur auserhalb möglich.
      halt
    }
    if ($isfile($char($nick)) == $false) && ($2 !isnum) {
      msg # Sry einen Nichtvorhandenen Spieler kann ich nicht helfen.
    }
  }
  if (%battleis == off) && (%pmd == true) {
    if ($isfile($char($nick)) == $true) && ($2 == $null) {
      var %mainhp $readini($char($nick), BaseStats, HP)
      var %enoughorbs $round($readini($char($nick), Stuff, redorbs),0)
      if (%enoughorbs >= %mainhp) {
        var %currentorbs $calc(%enoughorbs - %mainhp)
        writeini $char($nick) Stuff redorbs %currentorbs
        writeini $char($nick) Battle HP %mainhp
        msg # Heilung ist auserhalb möglich. Die Max HP die Geheilt wird beträgt %mainhp . Du hast zurzeit %enoughorbs RedOrbs. Du bezahlst %mainhp und hast dann noch übrig %currentorbs  
      }
    }
    if ($isfile($char($nick)) == $true) && ($2 isnum) {
      var %valheal $2
      var %mainhp $readini($char($nick), BaseStats, HP)
      if (%valheal > %mainhp) { 
        msg # Fehler du kannst dich nicht über die MaxHP heilen
        halt
      }
      if (%valheal <= %mainhp) {
        var  %currenthp $readini($char($nick), Battle, hp)
        var  %healcount $calc(%currenthp + %valheal)
        if (%healcount > %mainhp)  {
          msg # Sry %healcount ist größer als %mainhp
        }
        if (%healcount <= %mainhp) {
          var %enoughorbs $readini($char($nick), Stuff, redorbs)
          var %currentorbs $round($calc(%enoughorbs - %healcount),0)
          if (%enoughorbs >= %healcount) {
            writeini $char($nick) Stuff redorbs %currentorbs
            writeini $char($nick) Battle HP %healcount
            msg # Du hast dich um %healcount HP Punkten geheilt und bezahltest %valheal RedOrbs dafür. Deine Übrigen orbs sind dann %currentorbs .
          }
        }
      }
      if ($isfile($char($nick)) == $false) && ($2 isnum) {
        msg # Sry einen Nichtvorhandenen Spieler kann ich nicht helfen.
      }
      if ($isfile($char($nick)) == $false) && ($2 !isnum) {
        msg # Sry einen Nichtvorhandenen Spieler kann ich nicht helfen.
      }
    }
  }
}
