extends Node2D

const GHOST_REPLAY_SCENE := preload("res://scenes/replays/ghost_replay.tscn")
const ENEMY_REPLAY_SCENE := preload("res://scenes/replays/enemy_ghost.tscn")

@export var level_id: int = 0

@onready var player: CharacterBody2D = $Player
@onready var death_count_label: Label = $HUD/MarginContainer/VBoxContainer/DeathLabel
@onready var time_label: Label = $HUD/MarginContainer/VBoxContainer/TimeLabel
@onready var camera: Camera2D = $Camera2D
@onready var camera_bounds: ReferenceRect = $CameraBounds

var replay_elapsed_time := 0.0
var is_replay_active := false
var replayable_enemies: Array[Node] = []


func _ready() -> void:
	
	# get the replay enemies group
	replayable_enemies = get_tree().get_nodes_in_group("replayable_enemies")
	
	# get the camera limits based on the level's camera bounds
	camera.limit_left = int(camera_bounds.position.x)
	camera.limit_right = int(camera_bounds.position.x + camera_bounds.size.x)
	camera.limit_top = int(camera_bounds.position.y)
	camera.limit_bottom = int(camera_bounds.position.y + camera_bounds.size.y)
	
	camera.set_target(player)
	RunHistory.start_run()
	var record := GameProgress.get_level_record(level_id)
	
	if record.completed:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(record.best_run, true)
	

func _physics_process(delta: float) -> void:
	
	if RunHistory.is_run_active:
		RunHistory.record_frame(player.global_position, player.animated_sprite.animation)
		
		for enemy in replayable_enemies:
			if is_instance_valid(enemy):
				RunHistory.record_enemey_frame(enemy.replay_id, enemy.global_position, &"")
		
		death_count_label.text =  "Deaths: " + str(RunHistory.level_death_count)
		
	if is_replay_active:
		replay_elapsed_time += delta
		time_label.text = "Timer: " + "%.2f" % replay_elapsed_time + " s"

	else:
		time_label.text = "Timer: " + "%.2f" % RunHistory.run_elapsed_time + " s"
	
	

func _on_hazard_body_hit_hazard(body: Node2D) -> void:
	player.die()


func _on_end_level_door_exit_to_next_level(body: Node2D) -> void:
	
	for enemy_id in RunHistory.current_enemy_runs:
		print(
			"Enemy ", enemy_id,
			": ",
			RunHistory.current_enemy_runs[enemy_id].size(),
			" frames"
		)
	
	GameProgress.submit_level_result(level_id, RunHistory.run_elapsed_time,RunHistory.level_death_count, RunHistory.current_run)
	RunHistory.complete_run()
	
	#what did i have this here for? keeping it just in case
	var level_record = GameProgress.get_level_record(level_id)
	
	player.visible = false
	
	hide_replayable_enemies()
	
	replay_elapsed_time = 0.0
	is_replay_active = true
	spawn_ghosts()



func spawn_ghosts() -> void:
	for run in RunHistory.failed_runs:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(run.player_frames)
		
		for enemy_id in run.enemy_frames:		
			var enemy_ghost = ENEMY_REPLAY_SCENE.instantiate()
			$Ghosts.add_child(enemy_ghost)
			enemy_ghost.setup(run.enemy_frames[enemy_id])
		
	
	if RunHistory.successful_run:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(RunHistory.successful_run.player_frames, true)
		ghost.replay_finished.connect(_on_successful_replay_finished)
		camera.set_target(ghost)
		
		for enemy_id in RunHistory.successful_run.enemy_frames:
			var enemy_ghost = ENEMY_REPLAY_SCENE.instantiate()
			$Ghosts.add_child(enemy_ghost)
			enemy_ghost.setup(RunHistory.successful_run.enemy_frames[enemy_id])
		
		

func hide_replayable_enemies() -> void:
	for enemy in replayable_enemies:
		if is_instance_valid(enemy):
			enemy.visible = false
		
		
func _on_successful_replay_finished() -> void:
	is_replay_active = false
	
	# just for testing. remove when level select and other levels are available
	get_tree().call_deferred("reload_current_scene")


func _on_player_player_died() -> void:
	RunHistory.fail_run()
	get_tree().call_deferred("reload_current_scene")
