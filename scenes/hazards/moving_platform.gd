extends AnimatableBody2D

@export var travel_offset := Vector2(200,0)
@export var move_speed := 100.0
@export var pause_duration := 0.5
@export var replay_id : int
@export var replay_visual: PackedScene

var start_position: Vector2
var target_position: Vector2
var moving_to_target := true
var pause_timer := 0.0


func _ready() -> void:
	start_position = position
	
	target_position = start_position + travel_offset
	

func _physics_process(delta: float) -> void:
	
	if pause_timer > 0:
		pause_timer -= delta
		return
	
	if moving_to_target:	
		position = position.move_toward(
			target_position, 
			move_speed * delta)
			
		if position.is_equal_approx(target_position):
			moving_to_target = false
			pause_timer = pause_duration
			
	else:
		position = position.move_toward(
			start_position,
			move_speed * delta
		)
		
		if position.is_equal_approx(start_position):
			moving_to_target = true
			pause_timer = pause_duration
