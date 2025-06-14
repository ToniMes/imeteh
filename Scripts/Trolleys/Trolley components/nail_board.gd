extends Node3D
class_name NailBoard

signal all_nailed
@onready var nail1: Nail = $Nail
@onready var nail2: Nail = $Nail2
@onready var nail3: Nail = $Nail3
var nails = []
var pop_distance = 0.04


func _ready() -> void:
  nails.push_front(nail1)
  nails.push_front(nail2)
  nails.push_front(nail3)


func pop_up(index: int):
  var nail:Nail = nails.get(index)
  if nail.nailedFlag:
    nail.position.y += pop_distance
    nail.nailedFlag = false


func onNailed():
  print("Nailed!")
  if nail1.nailed and nail2.nailed and nail3.nailed:
    all_nailed.emit()
