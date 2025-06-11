extends Node3D
var nailed_count = 0
signal all_nailed

func onNailed():
  print("Nailed!")
  nailed_count += 1
  if nailed_count == 3:
    all_nailed.emit()
