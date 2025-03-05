extends CharacterBody2D

var speed := 100
@export var acceleration := 1200.0
@export var deceleration := 1080.0
const dash = 500
var tween: Tween
var dash_velocity = 0.0
func _ready() -> void:
	pass # Replace with function body.
func dashh():
	if Input.is_action_just_pressed("dash"):
		dash_velocity = dash
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "dash_velocity", 0, 0.2).set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
	if input_axis:
		move_and_slide()
