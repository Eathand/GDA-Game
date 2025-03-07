extends CharacterBody2D

var speed := 300
@export var acceleration := 10000
@export var deceleration := 10000
@export var dash_speed := 1500.0
@export var dash_duration := .2
@export var dash_cooldown := 1.5

var is_dashing := false
var dash_timer := 0.0
var dash_direction := Vector2.ZERO
var dash_velocity = 0.0
@onready var cooldown_timer = $Cooldown
func _ready() -> void:
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.one_shot = true



func _physics_process(delta: float) -> void:
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			cooldown_timer.start()
		velocity = dash_direction * dash_speed
	else:
		var direction := Input.get_vector("left", "right", "up", "down")
		var has_input_direction := direction.length() > 0.0
		if has_input_direction:
			var desired_velocity := direction * speed
			velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		if Input.is_action_just_pressed("dash") and has_input_direction and cooldown_timer.is_stopped():
			start_dash(direction)


	move_and_slide()
func start_dash(direction: Vector2):
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = direction
	cooldown_timer.stop()
