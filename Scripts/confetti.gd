extends Node3D

@onready var red: CPUParticles3D = $Red
@onready var blue: CPUParticles3D = $Blue
@onready var green: CPUParticles3D = $Green


func explode():
  red.emitting = true
  blue.emitting = true
  green.emitting = true
