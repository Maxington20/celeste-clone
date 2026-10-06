extends CharacterBody2D

@export var move_speed := 100.0
@export var travel_distance := 100.0
@export var bounce_velocity := -800
@export var replay_id: int
@export var replay_visual: PackedScene

var direction := 1.0
var start_position: Vector2


func _ready() -> void:
	start_position = global_position


func _physics_process(_delta: float) -> void:
	velocity.x = move_speed * direction

	move_and_slide()

	# Turn around if something blocks the walker.
	if is_on_wall():
		reverse_direction()

	# Turn around after travelling the configured patrol distance.
	elif abs(global_position.x - start_position.x) >= travel_distance:
		reverse_direction()


func reverse_direction() -> void:
	start_position = global_position
	direction *= -1


func _on_stomp_area_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	call_deferred("disable_collision_layers")
	body.velocity.y = bounce_velocity

	var tween = create_tween()
	tween.tween_property($Visuals, "scale", Vector2.ZERO, 0.2)

	await tween.finished
	queue_free()


func disable_collision_layers() -> void:
	$CollisionShape2D.disabled = true
	$StompArea/CollisionShape2D.disabled = true
	$DamageArea/CollisionShape2D.disabled = true


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
