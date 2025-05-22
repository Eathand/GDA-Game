extends CharacterBody2D

var speed := 175
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@export var max_health := 10000
@export var dash_speed := 600  # Speed during dash
@export var dash_duration := 0.2  # Time duration for dash
@export var dash_cooldown := 0.5  # Time before you can dash again
var dash_timer := 0.0  # Timer for dash duration
var dash_on_cooldown := false  # To check if dash is on cooldown
var direction := Vector2.ZERO  # Current movement direction	
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("dash") and !dash_on_cooldown: 
		start_dash()
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
func start_dash() -> void:
	dash_timer = dash_duration  # Set dash duration
	dash_on_cooldown = true
	# Start the cooldown timer
	#await(get_tree().create_timer(dash_cooldown), "timeout")  # Wait until the cooldown ends
	dash_on_cooldown = false
