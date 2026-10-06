extends AnimatableBody2D

@export var travel_offset := Vector2(200,0)
@export var move_speed := 100.0

var start_position: Vector2
var target_position: Vector2
var moving_to_target := true


func _ready() -> void:
	start_position = position
	
	target_position = start_position + travel_offset
	

func _physics_process(delta: float) -> void:
	
	if moving_to_target:	
		position = position.move_toward(
			target_position, 
			move_speed * delta)
			
		if position.is_equal_approx(target_position):
			moving_to_target = false
			
	else:
		position = global_position.move_toward(
			start_position,
			move_speed * delta
		)
		
		if position.is_equal_approx(start_position):
			moving_to_target = true
