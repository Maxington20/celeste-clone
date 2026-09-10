extends Node

var failed_runs: Array[Array] = []
var successful_run: Array[Vector2] = []
var current_run: Array[Vector2] = []
var level_death_count := 0
var run_elapsed_time := 0.00
var total_death_count := 0
var total_elapsed_time := 0.00
var is_run_active := false

func _physics_process(delta: float) -> void:
	if is_run_active:
		run_elapsed_time += delta

func start_run() -> void:
	current_run.clear()
	is_run_active = true
	
	
func record_position(position: Vector2) -> void:
	current_run.append(position)
	
	
func fail_run() -> void:
	is_run_active = false
	level_death_count += 1
	run_elapsed_time = 0
	failed_runs.append(current_run.duplicate())
	current_run.clear()
	
	
func complete_run() -> void:
	is_run_active = false
	successful_run = current_run.duplicate()
	total_death_count += level_death_count
	total_elapsed_time += run_elapsed_time
	current_run.clear()
	

func clear_history() -> void:
	failed_runs.clear()
	successful_run.clear()
	current_run.clear()
	level_death_count = 0
	run_elapsed_time = 0.0


		
		
		
