extends Area2D

signal body_hit_hazard(body: Node2D)

func _on_body_entered(body: Node2D) -> void:
	body_hit_hazard.emit(body)
