alias todo-fix {
  var %todoliste airorpg-todo.txt
  var %maxlines $lines(%todoliste)
  echo -ag Zeilenanzahl %maxlines
  var %x 1
  var %fixed 0
  var %fixedlabel 4→11F14i11X14Ed4←
  while (%x <= %maxlines) {
    if (%fixedlabel !isin $read(%todoliste,%x)) { inc %x }
    if (%fixedlabel isin $read(%todoliste,%x)) { 
      echo fixed ist in zeile %x
      msg %chan $gettok($read(%todoliste,%x),1-,32)
      inc %x
      inc %fixed
    }
  }
  msg %chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste 4,1 %fixed 14,1 Fixed Einträge 7,1[9▒7] 4→11I14rC-11M14inecraft4← 7[9▒7,1]
}

alias todo-fertig {
  var %todoliste airorpg-todo.txt
  var %maxlines $lines(%todoliste)
  echo -ag Zeilenanzahl %maxlines
  var %x 1
  var %fertig 0 
  var %fertiglabel 7,1[9√7]
  while (%x <= %maxlines) {
    if (%fertiglabel !isin $read(%todoliste,%x)) { inc %x }
    if (%fertiglabel isin $read(%todoliste,%x)) {
      msg %chan $gettok($read(%todoliste,%x),1-,32)
      inc %fertig
      inc %x
    }
  }
  msg %chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste 4,1 %fertig 14,1 Fertige Einträge 7,1[9▒7] 4→11I14rC-11M14inecraft4← 7[9▒7,1]
}

alias todo-neu {
  var %todoliste airorpg-todo.txt
  var %maxlines $lines(%todoliste)
  echo -ag Zeilenanzahl %maxlines
  var %x 1
  var %neu 0
  var %neulabel 7[8ↈ13NEU8ↈ7,1]
  while (%x <= %maxlines) {
    if (%neulabel !isin $read(%todoliste,%x)) { inc %x }
    if (%neulabel isin $read(%todoliste,%x)) {
      msg %chan 14,1 $gettok($read(%todoliste,%x),1-,32)
      inc %neu
      inc %x
    }
  }
  msg %chan 7,1[9▒7] 4→11A14iro-11R14PG4← 7[9▒7,1]14,1 Todo Liste 4,1 %neu 14,1 Neue Einträge 7,1[9▒7] 4→11I14rC-11M14inecraft4← 7[9▒7,1]
}
