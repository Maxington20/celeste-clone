extends CharacterBody2D

@export var move_speed := 100.0
@export var travel_distance := 100.0


signal body_hit_stomp_area(body: Node2D)

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


func _on_stomp_area_body_entered(body: Node2D) -> void:
	body_hit_stomp_area.emit(body)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	await tween.finished
