extends Node

var failed_runs: Array[RunRecording] = []
var successful_run: RunRecording
var current_run: Array[ReplayFrame] = []
var current_object_runs: Dictionary[int, Array ]= {}
var level_death_count := 0
var run_elapsed_time := 0.00
var is_run_active := false

func _physics_process(delta: float) -> void:
	if is_run_active:
		run_elapsed_time += delta

func start_run() -> void:
	current_run.clear()
	is_run_active = true
	
	
func record_frame(position: Vector2, animation: StringName) -> void:
	current_run.append(
		ReplayFrame.new(position, animation)
	)

func record_object_frame(id: int, position: Vector2, _animation: StringName, scale: Vector2, visual_position: Vector2) -> void:
	if !current_object_runs.has(id):
		var frames: Array[WorldReplayFrame] = []
		current_object_runs[id] = frames
	
	current_object_runs[id].append(
		WorldReplayFrame.new(
		position,
		scale,
		_animation,
		visual_position
		)
	)
	
	
	
func fail_run() -> void:
	is_run_active = false
	level_death_count += 1
	run_elapsed_time = 0
	
	var recording := RunRecording.new()
	recording.player_frames = current_run.duplicate()
	recording.object_frames = current_object_runs.duplicate()
	
	failed_runs.append(recording)
	current_run.clear()
	current_object_runs.clear()
	
	
func complete_run() -> void:
	is_run_active = false
	
	var run := RunRecording.new()
	run.player_frames = current_run.duplicate()
	run.object_frames = current_object_runs.duplicate()
	
	successful_run = run
	current_run.clear()
	current_object_runs.clear()
	

func clear_history() -> void:
	failed_runs.clear()
	successful_run.clear()
	current_run.clear()
	level_death_count = 0
	run_elapsed_time = 0.0
	
	
