extends Node2D

var positions: Array[Vector2] = []
var frame_index := 0


func setup(run_positions: Array[Vector2]) -> void:
	positions = run_positions.duplicate()
	frame_index = 0
	
func _physics_process(delta: float) -> void:
	
	if frame_index >= positions.size():
		return
		
	global_position = positions[frame_index]
	frame_index += 1
