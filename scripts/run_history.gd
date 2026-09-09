extends Node

var failed_runs: Array[Array] = []
var successful_run: Array[Vector2] = []
var current_run: Array[Vector2] = []


func start_run() -> void:
	current_run.clear()
	
	
func record_position(position: Vector2) -> void:
	current_run.append(position)
	
	
func fail_run() -> void:
	failed_runs.append(current_run.duplicate())
	current_run.clear()
	print(failed_runs.size())
	
	
func complete_run() -> void:
	successful_run = current_run.duplicate()
	current_run.clear()
	

func clear_history() -> void:
	failed_runs.clear()
	successful_run.clear()
	current_run.clear()



		
		
		
