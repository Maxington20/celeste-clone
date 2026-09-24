extends RefCounted

class_name WorldReplayFrame

var position: Vector2
var scale: Vector2
var animation: StringName	
var visual_position: Vector2

func _init(frame_position: Vector2, frame_scale: Vector2, frame_animation: StringName, frame_visual_position: Vector2) -> void:
	position = frame_position
	scale = frame_scale
	animation = frame_animation
	visual_position = frame_visual_position
