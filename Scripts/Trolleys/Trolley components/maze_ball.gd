extends RigidBody3D

var MAX_SPEED = 0.1

func _ready() -> void:
  continuous_cd = true

func _physics_process(delta: float) -> void:
  var velocity = sqrt(linear_velocity.x**2 + linear_velocity.y**2 + linear_velocity.z**2)
  if velocity > MAX_SPEED:
    var velocity_x = linear_velocity.x * sqrt(MAX_SPEED / velocity)
    var velocity_y = linear_velocity.y * sqrt(MAX_SPEED / velocity)
    var velocity_z = linear_velocity.z * sqrt(MAX_SPEED / velocity)
    linear_velocity = Vector3(velocity_x, velocity_y, velocity_z)


func _on_area_3d_body_entered(body: Node3D) -> void:
  if body == self:
    print("entered")


func _on_area_3d_body_exited(body: Node3D) -> void:
  if body == self:
    print("exited")
