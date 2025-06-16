extends Node3D
class_name ChunkMover

const CHUNK_1 = preload("res://Scenes/EnvironmentChunks/Chunk1.tscn")
const CHUNK_2 = preload("res://Scenes/EnvironmentChunks/Chunk2.tscn")
const CHUNK_3 = preload("res://Scenes/EnvironmentChunks/Chunk3.tscn")
const GRASS_1 = preload("res://Scenes/EnvironmentChunks/Grass1.tscn")
const GRASS_2 = preload("res://Scenes/EnvironmentChunks/Grass2.tscn")
const GRASS_3 = preload("res://Scenes/EnvironmentChunks/Grass3.tscn")
const CHUNK_SPLIT = preload("res://Scenes/EnvironmentChunks/Chunk_split.tscn")
const CHUNK_MERGE = preload("res://Scenes/EnvironmentChunks/Chunk_merge.tscn")
const turn_rotation = PI/4
const turn_offset: float = 2.355
const wide_render: bool = false
const load_distance: int = 6
const wide_load_distance:int = 4

@onready var chunk_parent: Node3D = $ChunkParent
@onready var trolley: Node3D = $"../Trolley"

var runningSfxPlayer: AudioStreamPlayer
var breakingSfxPlayer: AudioStreamPlayer

var split_tracker: Node3D
var merge_tracker: Node3D
var chunks: Array[Node3D]
var side_chunks: Array[Node3D]

var force_split_count = 1
var chunk_length: float = 50
var current_speed: float = 0
var target_speed: float = 0
var max_speed: float = 25
var chunk_count: int = 0

var target_offset_x: float = 0
var target_offset_y: float = 0
var target_rotation_x: float = 0
var target_rotation_y: float = 0
var target_rotation_z: float = 0
var turn_direction: int = -1
var turn_lock: bool = false

var is_jover = false
var merge = false
var split_check = true
var merge_check = true
# A class that moves, loads in and loads out chunks of the world

var victims: Array[Victim]
var shake_intensity: float = 0.5

func _ready():
  for k in load_distance:
    var r = randi()
    var new_chunk: Node3D
    if r%3 == 0:
      new_chunk = CHUNK_1.instantiate()
    elif r%3 == 1:
      new_chunk = CHUNK_2.instantiate()
    elif r%3 == 2:
      new_chunk = CHUNK_3.instantiate()
    new_chunk.position.z += chunk_length * k
    chunks.append(new_chunk)
    chunk_parent.add_child(new_chunk)
    chunk_count += 1
    
    if wide_render:
      for i in wide_load_distance * 2:
        r = randi()
        if r%3 == 0:
          new_chunk = GRASS_1.instantiate()
        elif r%3 == 1:
          new_chunk = GRASS_2.instantiate()
        elif r%3 == 2:
          new_chunk = GRASS_3.instantiate()
        
        new_chunk.position.z = chunks[chunks.size()-2].position.z + chunk_length
        var posx = i * chunk_length - wide_load_distance * chunk_length
        if posx >= 0: posx += chunk_length
        new_chunk.position.x = posx
        chunk_parent.add_child(new_chunk)
        side_chunks.append(new_chunk)
    
  Global.connectGlobalSignal(Global.trolley_acceleration_changed, on_acc_change)
  Global.connectGlobalSignal(Global.trolley_direction_changed, on_direction_change)
  
  
func _process(delta: float) -> void:
  current_speed = lerp(current_speed, target_speed, delta)
  
  # Stopping breaking sound if trolley is stopped
  if current_speed < 0.5 and breakingSfxPlayer:
    Audio.sfxPlayer.stop_stream_player(breakingSfxPlayer)
    breakingSfxPlayer = null
  
  var posdeg = Util.positiveDeg(rotation_degrees.y)
  var posrad = deg_to_rad(posdeg)
  #print(posdeg)
  for chunk in chunks:
    chunk.position.z -= current_speed * delta * cos(posrad)
  for chunk in side_chunks:
    chunk.position.z -= current_speed * delta * cos(posrad)
  
  if (posdeg > 35 and posdeg < 325):
      target_rotation_y = 0
      if !split_check:
        target_speed = max_speed
        
  if split_tracker:
    if split_tracker.position.z < 53 and split_check:
      target_speed = max_speed/6
      Global.trolley_track_changed.emit(turn_direction + 1)
    if split_tracker.position.z < 49.5 and split_check:
      turn_lock = true
      target_offset_x = turn_offset * turn_direction
      target_speed = max_speed
      target_rotation_y = turn_rotation * turn_direction
      split_check = false
  
  if merge_tracker:
    if merge_tracker.position.z < 11.5 and merge_check:
      target_speed = max_speed/6
    if merge_tracker.position.z < 7 and merge_check:
      target_offset_x = 0
      target_speed = max_speed
      target_rotation_y = turn_rotation * -turn_direction
      merge_check = false
  
  # Starting next level a couple of seconds after trolley merges back into single rail
  if !merge_tracker and !merge_check:
    var nextLevelTimer = Timer.new()
    nextLevelTimer.one_shot = true
    nextLevelTimer.wait_time = 20
    nextLevelTimer.timeout.connect(func(): Global.level_finished.emit())
    add_child(nextLevelTimer)
    nextLevelTimer.start()
      
  #print(posrad, " ~ ", sin(posrad))
  position.x = lerp(position.x, target_offset_x, delta * current_speed * abs(sin(posrad)))
  rotation.y = lerp(rotation.y, target_rotation_y, delta * current_speed / 3.5)
  
  #relevant when shaking
  position.y = lerp(position.y, target_offset_y, delta * current_speed * 2)
  rotation.x = lerp(rotation.x, target_rotation_x, delta * current_speed * 2)
  rotation.z = lerp(rotation.z, target_rotation_z, delta * current_speed * 2)
  
  if chunks[0].position.z <= 0:
    chunk_count += 1
    var r = randi()
    var new_chunk
    var offset_fix = 0
    if merge:
      new_chunk = CHUNK_MERGE.instantiate()
      merge_tracker = new_chunk
      merge = false
    elif is_jover or chunk_count == force_split_count:
      new_chunk = CHUNK_SPLIT.instantiate()
      split_tracker = new_chunk
      set_victims()
      merge = true
      is_jover = false
    elif r%3 == 0:
      new_chunk = CHUNK_1.instantiate()
    elif r%3 == 1:
      new_chunk = CHUNK_2.instantiate()
    elif r%3 == 2:
      new_chunk = CHUNK_3.instantiate()
      
    if chunks.back() == merge_tracker:
      offset_fix = -0.115
    new_chunk.position.z = chunks.back().position.z + chunk_length + offset_fix
    chunk_parent.add_child(new_chunk)
    var chunk_to_remove: Node = chunks.pop_front()
    chunk_to_remove.queue_free()
    chunk_parent.remove_child(chunk_to_remove)
    chunks.append(new_chunk)
    
    if wide_render:
      for i in wide_load_distance * 2:
        r = randi()
        if r%3 == 0:
          new_chunk = GRASS_1.instantiate()
        elif r%3 == 1:
          new_chunk = GRASS_2.instantiate()
        elif r%3 == 2:
          new_chunk = GRASS_3.instantiate()
        
        new_chunk.position.z = chunks[chunks.size()-2].position.z + chunk_length + offset_fix
        var posx = i * chunk_length - wide_load_distance * chunk_length
        if posx >= 0: posx += chunk_length
        new_chunk.position.x = posx
        chunk_parent.add_child(new_chunk)
        side_chunks.append(new_chunk)
        
      for i in wide_load_distance * 2:
        var to_remove = side_chunks.pop_front()
        to_remove.queue_free()
        chunk_parent.remove_child(to_remove)
        
    print("loaded chunk ", chunk_count)
    if Global.current_level == 1:
      if chunk_count == 11:
        Audio.narrator.play_voiceline("1_5") # Lvl15-NowIsAGoodATimeAsAnyToTellYou…
      elif chunk_count == 13:
        Audio.narrator.play_voiceline("1_6") # Lvl16-I’mHereForYou
    
    elif Global.current_level == 2:
      if chunk_count == 10:
        Audio.narrator.play_voiceline("2_6") # Lvl 2 6 - There will be kittens in front of you
        
    elif Global.current_level == 3:
      if chunk_count == 10:
        Audio.narrator.play_voiceline("3_3") # Lvl 3 3 - now is a good time as any
          
          
func on_acc_change(acceleration: int):
  target_speed = acceleration * max_speed
  
  # Playing breaking sfx if acc=0
  if acceleration == 0 and runningSfxPlayer:
    Audio.sfxPlayer.stop_stream_player(runningSfxPlayer)
    runningSfxPlayer = null
    breakingSfxPlayer = Audio.sfxPlayer.play_sound("sfx/broken_breaks.mp3", true)
  
  # Playing trolley running sfx if acc=1
  elif acceleration == 1 and !runningSfxPlayer:
    Audio.sfxPlayer.stop_stream_player(breakingSfxPlayer)
    breakingSfxPlayer = null
    runningSfxPlayer = Audio.sfxPlayer.play_sound("sfx/trolley_running_ambiance.mp3", true)


func on_direction_change(direction: Global.TrolleyDirection):
  if turn_lock:
    return
  if direction == Global.TrolleyDirection.RIGHT:
    turn_direction = 1
  else:
    turn_direction = -1


func prepare_victims(victims: Array[String]):
  for v in victims:
    self.victims.append(load("res://Scenes/Victims/" + v + ".tscn").instantiate())


func set_victims():
  var c: int = 0
  for v in victims:
    v.ran_over.connect(shake)
    split_tracker.add_child(v)
    v.position.x -= 2.335
    v.position.z -= 5 * c - 35
    c += 1


func shake():
  var oldPosY = target_offset_y
  var oldRotX = target_rotation_x
  var oldRotZ = target_rotation_z
  
  for i in range(5):
    target_offset_y = -0.3 - randf()/2 * shake_intensity
    target_rotation_x = (randf() - 0.5) * PI/6 * shake_intensity
    target_rotation_z = (randf() - 0.5) * PI/6 * shake_intensity
    await get_tree().create_timer(0.5 / current_speed).timeout
  
  target_offset_y = oldPosY
  target_rotation_x = oldRotX
  target_rotation_z = oldRotZ
