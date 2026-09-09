extends Node2D


func _on_hazard_body_hit_hazard(body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene")


func _on_end_level_door_exit_to_next_level(body: Node2D) -> void:
	print("yay! onto the next level")
