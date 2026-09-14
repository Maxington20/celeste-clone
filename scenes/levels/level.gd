extends Node2D

const GHOST_REPLAY_SCENE := preload("res://scenes/replays/ghost_replay.tscn")

@export var level_id: int = 0

@onready var player: CharacterBody2D = $Player
@onready var death_count_label: Label = $HUD/MarginContainer/VBoxContainer/DeathLabel
@onready var time_label: Label = $HUD/MarginContainer/VBoxContainer/TimeLabel

var replay_elapsed_time := 0.0
var is_replay_active := false

func _ready() -> void:
	RunHistory.start_run()
	var record := GameProgress.get_level_record(level_id)
	
	if record.completed:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(record.best_run, true)
	

func _physics_process(delta: float) -> void:
	
	if RunHistory.is_run_active:
		RunHistory.record_frame(player.global_position, player.animated_sprite.animation)
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
	GameProgress.submit_level_result(level_id, RunHistory.run_elapsed_time,RunHistory.level_death_count, RunHistory.current_run)
	
	RunHistory.complete_run()
	
	var level_record = GameProgress.get_level_record(level_id)
	
	print(level_record.best_run, level_record.best_time, level_record.completed)
	
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
	
	# just for testing. remove when level select and other levels are available
	get_tree().call_deferred("reload_current_scene")
