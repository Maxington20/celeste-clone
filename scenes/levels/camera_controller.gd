extends Camera2D

const LOOK_AHEAD_DISTANCE := 150
const LOOK_AHEAD_SPEED := 300

var target: Node2D
var last_position: Vector2
var movement_x: float
var movement_y: float
var look_ahead_x := 0.0
var look_ahead_y := 0.0

func _process(_delta: float) -> void:
	
	if target:		
		movement_x = sign(target.global_position.x - last_position.x)
		movement_y = sign(target.global_position.y - last_position.y)
		last_position = target.global_position		
		global_position = target.global_position
		
		look_ahead_x = move_toward(
			look_ahead_x,
			movement_x * LOOK_AHEAD_DISTANCE,
			LOOK_AHEAD_SPEED * _delta
		)
		
		look_ahead_y = move_toward(
			look_ahead_y,
			movement_y * LOOK_AHEAD_DISTANCE,
			LOOK_AHEAD_SPEED * _delta
		)
		
		global_position.x = target.global_position.x + look_ahead_x
		global_position.y = target.global_position.y + look_ahead_y
		

func set_target(new_target: Node2D) -> void:
	target = new_target
	last_position = new_target.global_position
