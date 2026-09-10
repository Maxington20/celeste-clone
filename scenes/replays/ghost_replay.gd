extends Node2D

signal replay_finished

var positions: Array[Vector2] = []
var frame_index := 0
var successful := false

func setup(run_positions: Array[Vector2], was_successful: bool = false) -> void:
	positions = run_positions.duplicate()
	frame_index = 0
	successful = was_successful
	
func _physics_process(delta: float) -> void:
	
	if frame_index >= positions.size():
		
		if successful:
			replay_finished.emit()
		else:
			queue_free()
		return
		
	global_position = positions[frame_index]
	frame_index += 1
