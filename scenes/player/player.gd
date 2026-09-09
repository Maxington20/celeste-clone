extends CharacterBody2D


const GRAVITY := 1000.0
const SPEED := 200.0
const JUMP_VELOCITY := -600.0
const ACCELERATION := 150	 
const DECELERATION := 250
const COYOTE_TIME := 0.1

var coyote_timer := 0.0

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		
	else:
		coyote_timer -= delta
		velocity.y += GRAVITY * delta
	
	if coyote_timer > 0 and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0
	
	if Input.is_action_just_released("jump") and velocity.y < 0:			
		velocity.y *= 0.5
	
	var direction := Input.get_axis("move_left", "move_right")
	
	 ## velocity.x = SPEED * direction
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	
	move_and_slide()
