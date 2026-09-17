extends CharacterBody2D

@export var move_speed := 100.0
@export var travel_distance := 100.0

var direction := 1.0
var start_position: Vector2


func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	
	velocity.x = move_speed *  direction
	
		
	if abs(global_position.x - start_position.x) >= travel_distance:
		start_position = global_position
		direction *= -1
		
	move_and_slide()
