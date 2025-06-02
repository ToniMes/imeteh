extends Node


func positiveDeg(val: float) -> float:
  return val if val > 0 else 360 - val
