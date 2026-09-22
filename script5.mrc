on 100:text:!RPGtodo*:#: {
  var %befehle add.del.fertig.fixed.list
  if ($2 == $null) { 
    msg $chan 7,1[9▒7] 4→11T14odo-11L14isten-11E14rsteller4← 7[9▒7,1] v1.0 by Serkons - Die Befehle sind:
    var %befehle add.del.fertig.fixed.list
    var %maxbefehle $numtok(%befehle,46)
    var %x 1
    while (%x <= %maxbefehle) {
      msg $chan 7,1[9▒7] 4,1→ $+ 7,1!rpgtodo $gettok(%befehle,%x,46) $iif($gettok(%befehle,%x,46) != list, <eintrag>, $chr(32)) 14 $iif($gettok(%befehle,%x,46) != list, $remove($read(todo-befehle.txt,w,$gettok(%befehle,%x,46) $+ *),$gettok(%befehle,%x,46),=), $replace($remove($read(todo-befehle.txt,w,$gettok(%befehle,%x,46) $+ *),=,list),Todoe,TodoListe))
      inc %x
    }
  }
  if ($istok(%befehle,$2,46) == $true) && ($2 == add) { 
    set %todolines $lines(airorpg-todo.txt)
    if (%todolines == $null) || (%todolines >= 0) { 
      inc %todolines
      ;;;msg $chan Zeile %todolines
      write -l $+ %todolines airorpg-todo.txt 7,1[9▒7] 4→7 $+ $fulldate $+ 4← 7[9▒7,1] 14 ID: 4→9 %todolines 15 4← 14 $3- 7[8ↈ13NEU8ↈ7,1]
      msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Eintrag ID: %todolines 4HINZUGEFÜGT!
      msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Text: 14 $3-
    }
  }  
  if ($istok(%befehle,$2,46) == $true) && ($2 == list) && ($3 == $null) { 
    msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]
    msg $chan 7,1[9√7]14 = Fertig - 7,1[9▒7] 4→11F14i11X14Ed4← 7[9▒7,1]14 = Optimiert / Fehlerbehoben
    play $chan airorpg-todo.txt
    /halt
  }
  if ($istok(%befehle,$2,46) == $true) && ($2 == list) && ($3 == fixed) { 
    msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste Fixed Einträge 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]
    set -u5 %chan $chan
    $todo-fix
    /halt
  }
  if ($istok(%befehle,$2,46) == $true) && ($2 == list) && ($3 == fertig) { 
    msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste Fertige Einträge 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]
    set -u5 %chan $chan
    $todo-fertig
    /halt
  }
  if ($istok(%befehle,$2,46) == $true) && ($2 == list) && ($3 == neu) { 
    msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste Neue Einträge 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]
    set -u5 %chan $chan
    $todo-neu
    /halt
  }

  if ($istok(%befehle,$2,46) == $true) && ($2 == del) { 
    var %eintragid $3
    set %eintragstext $read(airorpg-todo.txt,%eintragid)
    if (%eintragstext == $null) { msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste 4FEHLER:14 Sorry einen Eintrag mit ID: 7 %eintragid $+  existiert nicht! | /halt }
    ;;;msg $chan Eintragstoken: %eintragstokens
    if (%eintragstext != $null) && (%tododel == $null) { msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste  Soll der Eintrag: 7 $remove($gettok(%eintragstext,15-,32), 7[8ↈ13NEU8ↈ7,1],$chr(44))  wirklich Gelöscht werden?. Zur Bestätigung Befehl inerhalb von 5sec Erneut schreiben! | /set -u5 %tododel on | /halt }
    if (%eintragstext != $null) && (%tododel == on) {
      msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Listeneintrag 7,1[9▒7] 4→11 $+ $remove($gettok(%eintragstext,15-,32), 7[8ↈ13NEU8ↈ7,1],$chr(44)) $+ 4← 7[9▒7,1] 7[4GELÖSCHT!7,1] 
      /write -dl $+ %eintragid airorpg-todo.txt
      /sortlist
      msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste wurde Sortiert. Siehe !rpgtodo list
      /halt
    }
  }
  if ($istok(%befehle,$2,46) == $true) && ($2 == fertig) {
    var %eintrag $read(airorpg-todo.txt,$3)
    var %date $remove($gettok(%eintrag,2-6,32),←,→,47,4)
    if (%eintrag == $null) { msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste 4FEHLER:14 Sorry ein Eintrag mit id 4 $3 14 existiert nicht | /halt }  
    if (%eintrag != $null) {
      var %neulabel 7[8ↈ13NEU8ↈ7,1]
      var %fertiglabel 7,1[9√7]
      var %zeile $3
      write -l $+ %zeile airorpg-todo.txt $replace(%eintrag,%neulabel,%fertiglabel,%date,$fulldate)
      msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste - 14Der Eintrag wurde mit %fertiglabel gekennzeichnet.
    }
  }
  if ($istok(%befehle,$2,46) == $true) && ($2 == fixed) {
    var %eintrag $read(airorpg-todo.txt,$3)
    var %date $remove($gettok(%eintrag,2-6,32),←,→,47,4)
    if (%eintrag == $null) { msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste 4FEHLER:14 Sorry ein Eintrag mit id 4 $3 14 existiert nicht | /halt }  
    if (%eintrag != $null) {
      var %neulabel 7[8ↈ13NEU8ↈ7,1]
      var %fertiglabel 7,1[9√7]
      var %fixedlabel 7,1[9▒7] 4→11F14i11X14Ed4← 7[9▒7,1]
      var %zeile $3
      msg $chan Eintrag ist: %eintrag
      msg $chan Das Datum ist: %date
      msg $chan Das Updatedatum ist $fulldate
      write -l $+ %zeile airorpg-todo.txt $replace(%eintrag,%neulabel,%fixedlabel,%fertiglabel,%fixedlabel,%date,$fulldate))
      msg $chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1] Todo Liste - 14Der Eintrag wurde mit %fixedlabel gekennzeichnet.
    }
  }
}
Alias sortlist {
  var %maxlines $lines(airorpg-todo.txt)
  echo -ag Lines: %maxlines
  var %x 1
  while (%x <= %maxlines) {
    var %id $read(airorpg-todo.txt,%x)
    echo -ag Eintrag in Zeile: %x = %id
    var %idtoken $gettok(%id,10-13,32)
    echo -ag Idtoken in Zeile: %x = %idtoken
    if (%x !isin %idtoken) || (%x isin %idtoken) { var %newidtoken 4→9 %x 15 4← }
    echo -ag Neues Idtoken in Zeilen %x = %newidtoken
    echo -ag Neuer Text mit richtiger ID: $replace(%id,%idtoken,%newidtoken)
    /write -l $+ %x airorpg-todo.txt $replace(%id,%idtoken,%newidtoken)
    inc %x
  }
}
