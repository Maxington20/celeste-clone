extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY := 1000.0
const SPEED := 350.0
const JUMP_VELOCITY := -600.0
const ACCELERATION := 200
const DECELERATION := 1500
const AIR_ACCELERATION := 1500.0
const GROUND_DECELERATION := 2000.0
const AIR_DECELERATION := 300.0
const COYOTE_TIME := 0.1
const JUMP_BUFFER_TIME := 0.1
const WALL_SLIDE_SPEED := 250.0
const WALL_JUMP_PUSH := 300.0
const TURN_ACCELERATION := 2000.0
const DASH_SPEED := 1000.0
const WALL_COYOTE_TIME := 0.1
const DASH_DURATION := 0.12

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var jump_cut := false
var jump_released := false
var air_dash_available := true
var wall_coyote_timer := 0.0
var last_wall_normal := Vector2.ZERO
var last_faciing_direction := 1.0

var is_dashing := false
var dash_timer := 0.0
var dash_direction := 0.0


func _physics_process(delta: float) -> void:
	var wall_jump_this_frame := false

	# Dash timer
	if is_dashing:
		dash_timer -= delta

		if dash_timer <= 0:
			is_dashing = false

	# Coyote time and gravity
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		air_dash_available = true
	else:
		coyote_timer -= delta
		velocity.y += GRAVITY * delta

	# Wall detection / wall dash recharge
	if is_on_wall():
		air_dash_available = true
		wall_coyote_timer = WALL_COYOTE_TIME
		last_wall_normal = get_wall_normal()
	else:
		wall_coyote_timer -= delta

	# Dash
	if Input.is_action_just_pressed("dash") and air_dash_available and !is_on_floor():
		var input_direction := Input.get_axis("move_left", "move_right")

		if input_direction != 0:
			
			last_faciing_direction = input_direction
			
			dash_direction = input_direction
			dash_timer = DASH_DURATION
			is_dashing = true

			velocity.x = dash_direction * DASH_SPEED
			velocity.y = 0

			air_dash_available = false

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
	if wall_coyote_timer > 0 and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		velocity.x = last_wall_normal.x * WALL_JUMP_PUSH

		wall_coyote_timer = 0
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

	if !wall_jump_this_frame:
		if direction != 0:
			
			last_faciing_direction = direction
			
			var acceleration := ACCELERATION

			if !is_on_floor():
				acceleration = AIR_ACCELERATION
			elif sign(direction) != sign(velocity.x) and velocity.x != 0:
				acceleration = TURN_ACCELERATION

			velocity.x = move_toward(
				velocity.x,
				direction * SPEED,
				acceleration * delta
			)
		else:
			var deceleration := GROUND_DECELERATION

			if !is_on_floor():
				deceleration = AIR_ACCELERATION

			velocity.x = move_toward(
				velocity.x,
				0,
				deceleration * delta
			)

	animate_player(direction)

	move_and_slide()


func animate_player(direction: float) -> void:
	if is_dashing:
		if dash_direction < 0:
			animated_sprite.play("dash_left")
			animated_sprite.position.x = 6
		else:
			animated_sprite.play("dash_right")
			animated_sprite.position.x = -6

	elif direction < 0 and is_on_floor():
		animated_sprite.play("move_left")
		animated_sprite.position.x = 0

	elif direction > 0 and is_on_floor():
		animated_sprite.play("move_right")
		animated_sprite.position.x = 0

	elif direction == 0:
		if last_faciing_direction < 0:
			animated_sprite.play("idle_left")
		else:
			animated_sprite.play("idle_right")
		animated_sprite.position.x = 0
