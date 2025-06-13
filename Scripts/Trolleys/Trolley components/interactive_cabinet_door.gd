# class decribing the behaviour of a cabinet door
extends InteractiveObject
class_name InteractiveCabinetDoor

var doorState = Global.DoorState.CLOSED
var prevDoorState = Global.DoorState.CLOSED

func _process(delta):
  # while griped, the lever rotates in the Y plane to follow the hand
  if isGripped and hand:
    physParent.look_at(hand.global_position)
    physParent.rotation.y += PI/2
    physParent.rotation.x = 0
    physParent.rotation.z = 0
    
    # emitting event if door opened/closed
    if physParent.global_rotation_degrees.y > 0 and physParent.global_rotation_degrees.y < 170:
      doorState = Global.DoorState.OPEN
    else:
      doorState = Global.DoorState.CLOSED
    if prevDoorState != doorState:
      Global.cabinet_door_state_changed.emit(doorState)
    prevDoorState = doorState
  
    #the following limits the door's range of motion
    var posRotY: float = Util.positiveDeg(physParent.rotation_degrees.y)
    if posRotY < 90:
      physParent.rotation_degrees.y = 0
    elif posRotY < 225:
      physParent.rotation_degrees.y = 225
