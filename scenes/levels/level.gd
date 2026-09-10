extends Node2D

const GHOST_REPLAY_SCENE := preload("res://scenes/replays/ghost_replay.tscn")

@onready var player: CharacterBody2D = $Player
@onready var death_count_label: Label = $HUD/MarginContainer/VBoxContainer/DeathLabel
@onready var time_label: Label = $HUD/MarginContainer/VBoxContainer/TimeLabel

var replay_elapsed_time := 0.0
var is_replay_active := false

func _ready() -> void:
	RunHistory.start_run()
	

func _physics_process(delta: float) -> void:
	
	if RunHistory.is_run_active:
		RunHistory.record_position(player.global_position)
		death_count_label.text =  "Deaths: " + str(RunHistory.level_death_count)
		
	if is_replay_active:
		replay_elapsed_time += delta
		time_label.text = "Timer: " + "%.2f" % replay_elapsed_time + " s"

	else:
		time_label.text = "Timer: " + "%.2f" % RunHistory.run_elapsed_time + " s"
	
	

func _on_hazard_body_hit_hazard(body: Node2D) -> void:
	RunHistory.fail_run()	
	get_tree().call_deferred("reload_current_scene")


func _on_end_level_door_exit_to_next_level(body: Node2D) -> void:
	RunHistory.complete_run()
	player.visible = false
	
	replay_elapsed_time = 0.0
	is_replay_active = true
	
	spawn_ghosts()



func spawn_ghosts() -> void:
	for run in RunHistory.failed_runs:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(run)
		
	
	if !RunHistory.successful_run.is_empty():
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(RunHistory.successful_run, true)
		ghost.replay_finished.connect(_on_successful_replay_finished)
		
		
		
func _on_successful_replay_finished() -> void:
	is_replay_active = false
