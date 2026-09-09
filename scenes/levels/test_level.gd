extends Node2D


func _on_hazard_body_hit_hazard(body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene")
