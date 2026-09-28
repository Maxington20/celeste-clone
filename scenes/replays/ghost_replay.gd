extends Node2D

signal replay_finished

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var frames: Array[ReplayFrame] = []
var frame_index := 0
var is_successful_run := false


func setup(
	run_frames: Array[ReplayFrame],
	successful_run: bool = false
) -> void:
	frames = run_frames.duplicate()
	is_successful_run = successful_run
	frame_index = 0

	if !frames.is_empty():
		var first_frame := frames[0]

		global_position = first_frame.position
		animated_sprite.animation = first_frame.animation
		animated_sprite.flip_h = first_frame.flip_h
		animated_sprite.position = first_frame.sprite_position


func _physics_process(_delta: float) -> void:
	if frame_index >= frames.size():
		if is_successful_run:
			replay_finished.emit()

		queue_free()
		return

	var replay_frame := frames[frame_index]

	global_position = replay_frame.position

	if animated_sprite.animation != replay_frame.animation:
		animated_sprite.play(replay_frame.animation)

	animated_sprite.flip_h = replay_frame.flip_h
	animated_sprite.position = replay_frame.sprite_position

	frame_index += 1
