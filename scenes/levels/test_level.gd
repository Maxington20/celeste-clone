extends Node2D

const GHOST_REPLAY_SCENE := preload("res://scenes/replays/ghost_replay.tscn")

@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	RunHistory.start_run()
	

func _physics_process(delta: float) -> void:
	RunHistory.record_position(player.global_position)
	

func _on_hazard_body_hit_hazard(body: Node2D) -> void:
	RunHistory.fail_run()
	get_tree().call_deferred("reload_current_scene")


func _on_end_level_door_exit_to_next_level(body: Node2D) -> void:
	RunHistory.complete_run()
	spawn_ghosts()
	print("yay! onto the next level")


func spawn_ghosts() -> void:
	for run in RunHistory.failed_runs:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		add_child(ghost)
		ghost.setup(run)
		
	
	if !RunHistory.successful_run.is_empty():
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		add_child(ghost)
		ghost.setup(RunHistory.successful_run)
