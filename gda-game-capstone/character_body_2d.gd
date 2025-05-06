extends CharacterBody2D

const SPEED = 400.0
const speed = 400.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var acceleration := 1000000
@export var deceleration := 1000000

func _physics_process(delta: float) -> void:

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if Input.is_action_just_pressed("right"):
		animated_sprite_2d.flip_h = true
	if Input.is_action_just_pressed("left"):
		animated_sprite_2d.flip_h = false
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		var desired_velocity := direction * speed    
		animated_sprite_2d.stop()
	move_and_slide()
