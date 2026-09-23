extends Node2D

var frames: Array[ReplayFrame] = []
var frame_index := 0


func setup(run_frames: Array[ReplayFrame]) -> void:
	frames = run_frames.duplicate()
	
	frame_index = 0
	
	if !frames.is_empty():
		global_position = frames[0].position


func _physics_process(_delta: float) -> void:
	
	if frame_index >= frames.size():		
		queue_free()
		return

	var replay_frame := frames[frame_index]

	global_position = replay_frame.position

	frame_index += 1
