extends Node2D

signal replay_finished

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D

var frames: Array[ReplayFrame] = []
var frame_index := 0
var successful := false


func setup(run_frames: Array[ReplayFrame], was_successful: bool = false) -> void:
	frames = run_frames.duplicate()
	frame_index = 0
	successful = was_successful

	if !frames.is_empty():
		global_position = frames[0].position


func _physics_process(_delta: float) -> void:
	if frame_index >= frames.size():
		if successful:
			replay_finished.emit()
			set_physics_process(false)
		else:
			queue_free()

		return

	var replay_frame := frames[frame_index]

	global_position = replay_frame.position
	animation_sprite.play(replay_frame.animation)

	# Match your player's dash sprite offset
	if replay_frame.animation == &"dash_left":
		animation_sprite.position.x = 6
	elif replay_frame.animation == &"dash_right":
		animation_sprite.position.x = -6
	else:
		animation_sprite.position.x = 0

	frame_index += 1
