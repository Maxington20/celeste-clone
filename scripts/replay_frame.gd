extends RefCounted

class_name ReplayFrame

var position: Vector2
var animation: StringName
var flip_h: bool
var sprite_position: Vector2


func _init(
	frame_position: Vector2,
	frame_animation: StringName,
	frame_flip_h: bool,
	frame_sprite_position: Vector2
) -> void:
	position = frame_position
	animation = frame_animation
	flip_h = frame_flip_h
	sprite_position = frame_sprite_position
