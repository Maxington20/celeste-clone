extends Node

var failed_runs: Array[Array] = []
var successful_run: Array[ReplayFrame] = []
var current_run: Array[ReplayFrame] = []
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
	
	
func fail_run() -> void:
	is_run_active = false
	level_death_count += 1
	run_elapsed_time = 0
	failed_runs.append(current_run.duplicate())
	current_run.clear()
	
	
func complete_run() -> void:
	is_run_active = false
	successful_run = current_run.duplicate()
	current_run.clear()
	

func clear_history() -> void:
	failed_runs.clear()
	successful_run.clear()
	current_run.clear()
	level_death_count = 0
	run_elapsed_time = 0.0
	
	
