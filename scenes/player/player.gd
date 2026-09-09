extends CharacterBody2D


const GRAVITY := 1000.0
const SPEED := 200.0
const JUMP_VELOCITY := -600.0
const ACCELERATION := 150
const DECELERATION := 500
const AIR_ACCELERATION := 1000.0
const COYOTE_TIME := 0.1
const JUMP_BUFFER_TIME := 0.1
const WALL_SLIDE_SPEED := 250.0
const WALL_JUMP_PUSH := 300.0

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var jump_cut := false
var jump_released := false


func _physics_process(delta: float) -> void:
	
	var wall_jump_this_frame := false
	
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
	
	
	# Wall jump
	if is_on_wall() and Input.is_action_just_pressed("jump"):
		var wall_normal := get_wall_normal()
		
		velocity.y = JUMP_VELOCITY
		velocity.x = wall_normal.x * WALL_JUMP_PUSH
		
		jump_buffer_timer = 0
		jump_cut = false
		jump_released = false
		wall_jump_this_frame = true
	
	
	# Normal jump / coyote jump / buffered jump
	elif coyote_timer > 0 and jump_buffer_timer > 0:
		velocity.y = JUMP_VELOCITY
		
		coyote_timer = 0
		jump_buffer_timer = 0
		jump_cut = false
	
	
	# Cut the jump short if the button has been released
	if jump_released and velocity.y < 0 and !jump_cut:
		velocity.y *= 0.5
		jump_cut = true
	
	
	# Wall slide
	if is_on_wall() and velocity.y > 0:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
	
	
	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	
	# Don't immediately overwrite the horizontal push from a wall jump
	if !wall_jump_this_frame:
		if direction != 0:
			
			var acceleration := ACCELERATION
			
			if !is_on_floor():
				acceleration = AIR_ACCELERATION
			
			velocity.x = move_toward(
				velocity.x,
				direction * SPEED,
				acceleration * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				0,
				DECELERATION * delta
			)
	
	
	move_and_slide()
