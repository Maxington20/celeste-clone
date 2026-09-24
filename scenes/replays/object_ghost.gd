extends Node2D

var frames: Array[WorldReplayFrame] = []
var frame_index := 0
var scene: Node


func setup(run_frames: Array[WorldReplayFrame], packed_scene: PackedScene) -> void:
	frames = run_frames.duplicate()
	
	scene = packed_scene.instantiate()
	
	$Visuals.add_child(scene)
	
	frame_index = 0
	
	if !frames.is_empty():
		global_position = frames[0].position


func _physics_process(_delta: float) -> void:
	
	if frame_index >= frames.size():		
		queue_free()
		return

	var replay_frame := frames[frame_index]

	global_position = replay_frame.position
	get_node("Visuals").scale = replay_frame.scale
	get_node("Visuals").position = replay_frame.visual_position

	frame_index += 1
