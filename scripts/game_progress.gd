extends Node

var level_records: Dictionary[int, LevelRecord] = {}

var total_death_count := 0
var total_elapsed_time := 0.0


func get_level_record(level_id: int) -> LevelRecord:
	if !level_records.has(level_id):
		level_records[level_id] = LevelRecord.new()
		
	return level_records[level_id]


func submit_level_result(
	level_id: int,
	run_time: float,
	death_count: int,
	run_positions: Array[Vector2]
) -> void:
	var record := get_level_record(level_id)
	
	total_death_count += death_count
	total_elapsed_time =+ run_time
	
	
	
	if !record.completed or run_time < record.best_time:		
		record.best_time = run_time
		record.best_run = run_positions.duplicate()

	record.completed = true
