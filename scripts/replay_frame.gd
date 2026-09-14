extends RefCounted

class_name ReplayFrame


var position : Vector2
var animation: StringName


func _init(frame_position: Vector2, frame_animation: StringName) -> void:
	position = frame_position
	animation = frame_animation
