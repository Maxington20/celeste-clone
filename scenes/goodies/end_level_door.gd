extends Area2D

signal exit_to_next_level(body: Node2D)

func _on_body_entered(body: Node2D) -> void:
	exit_to_next_level.emit(body)
