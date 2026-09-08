extends CharacterBody2D


const GRAVITY := 1000.0
const SPEED := 200.0
const JUMP_VELOCITY := -400.0

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left", "move_right")
	
	velocity.x = SPEED * direction
	
	move_and_slide()
