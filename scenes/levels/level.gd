extends Node2D

const GHOST_REPLAY_SCENE := preload("res://scenes/replays/ghost_replay.tscn")
const OBJECT_REPLAY_SCENE := preload("res://scenes/replays/object_ghost.tscn")

@export var level_id: int = 0

@onready var player: CharacterBody2D = $Player
@onready var death_count_label: Label = $HUD/MarginContainer/VBoxContainer/DeathLabel
@onready var time_label: Label = $HUD/MarginContainer/VBoxContainer/TimeLabel
@onready var camera: Camera2D = $Camera2D
@onready var camera_bounds: ReferenceRect = $CameraBounds

var replay_elapsed_time := 0.0
var is_replay_active := false
var replayable_objects: Array[Node] = []
var replay_visuals: Dictionary[int, PackedScene] = {}


func _ready() -> void:
	
	# get the replay enemies group
	replayable_objects = get_tree().get_nodes_in_group("replayable_objects")
	
	for object in replayable_objects:
		replay_visuals[object.replay_id] = object.replay_visual
	
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
		
		for object in replayable_objects:
			if is_instance_valid(object):
				RunHistory.record_object_frame(object.replay_id, object.global_position, &"", object.get_node("Visuals").scale, object.get_node("Visuals").position)
		
		death_count_label.text =  "Deaths: " + str(RunHistory.level_death_count)
		
	if is_replay_active:
		replay_elapsed_time += delta
		time_label.text = "Timer: " + "%.2f" % replay_elapsed_time + " s"

	else:
		time_label.text = "Timer: " + "%.2f" % RunHistory.run_elapsed_time + " s"
	
	

func _on_hazard_body_hit_hazard(body: Node2D) -> void:
	player.die()


func _on_end_level_door_exit_to_next_level(body: Node2D) -> void:
	
	GameProgress.submit_level_result(level_id, RunHistory.run_elapsed_time,RunHistory.level_death_count, RunHistory.current_run)
	RunHistory.complete_run()
	
	#what did i have this here for? keeping it just in case
	var level_record = GameProgress.get_level_record(level_id)
	
	player.visible = false
	
	hide_replayable_objects()
	
	replay_elapsed_time = 0.0
	is_replay_active = true
	spawn_ghosts()



func spawn_ghosts() -> void:
	for run in RunHistory.failed_runs:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(run.player_frames)
		
		for object_id in run.object_frames:		
			var object_ghost = OBJECT_REPLAY_SCENE.instantiate()
			$Ghosts.add_child(object_ghost)
			object_ghost.setup(
					run.object_frames[object_id],
					replay_visuals[object_id]
				)
		
	
	if RunHistory.successful_run:
		var ghost = GHOST_REPLAY_SCENE.instantiate()
		$Ghosts.add_child(ghost)
		ghost.setup(RunHistory.successful_run.player_frames, true)
		ghost.replay_finished.connect(_on_successful_replay_finished)
		camera.set_target(ghost)
		
		for object_id in RunHistory.successful_run.object_frames:
			var object_ghost = OBJECT_REPLAY_SCENE.instantiate()
			$Ghosts.add_child(object_ghost)
			object_ghost.setup(
					RunHistory.successful_run.object_frames[object_id],
					replay_visuals[object_id]
				)
		
		

func hide_replayable_objects() -> void:
	for object in replayable_objects:
		# this will have to adjust depending on enemy or platform etc.
		if is_instance_valid(object):
			object.visible = false
		
		
func _on_successful_replay_finished() -> void:
	is_replay_active = false
	
	# just for testing. remove when level select and other levels are available
	get_tree().call_deferred("reload_current_scene")


func _on_player_player_died() -> void:
	RunHistory.fail_run()
	get_tree().call_deferred("reload_current_scene")
