extends CharacterBody2D


const GRAVITY := 1000.0
const SPEED := 200.0
const JUMP_VELOCITY := -600.0
const ACCELERATION := 150
const DECELERATION := 400
const COYOTE_TIME := 0.1
const JUMP_BUFFER_TIME := 0.1
const WALL_SLIDE_SPEED := 250

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var jump_cut := false
var jump_released := false


func _physics_process(delta: float) -> void:
	
	# Coyote time and gravity
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
		velocity.y += GRAVITY * delta	
	
	# Remember a jump press for a short time
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
		jump_released = false
	else:
		jump_buffer_timer -= delta
	
	# Remember if the player releases jump
	if Input.is_action_just_released("jump"):
		jump_released = true
	
	
	# Perform jump if both timers are still valid
	if coyote_timer > 0 and jump_buffer_timer > 0:
		velocity.y = JUMP_VELOCITY
		
		coyote_timer = 0
		jump_buffer_timer = 0
		jump_cut = false
	
	
	# Cut the jump short if the button has been released
	if jump_released and velocity.y < 0 and !jump_cut:
		velocity.y *= 0.5
		jump_cut = true
		
	
	if is_on_wall() and velocity.y > 0:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
	
	
	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * SPEED,
			ACCELERATION * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			DECELERATION * delta
		)
	
	move_and_slide()
