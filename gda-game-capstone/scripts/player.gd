extends CharacterBody2D
class_name Player
var speed := 300
@export var max_health := 100
@onready var dmgcool: Timer = $DamageCooldown
@onready var sprite_2d: Sprite2D = $root/Sprite2D

@onready var sword: Sword = $root/Sword

@export var acceleration := 100000
@export var deceleration := 100000
@export var dash_speed := 1500.0
@export var dash_duration := .2
@export var dash_cooldown := 1.5
var current_health := max_health
var is_dashing := false
var dash_timer := 0.0
var dash_direction := Vector2.ZERO
var dash_velocity = 0.0
@onready var cooldown_timer = $Cooldown
func _ready() -> void:
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.one_shot = true

func die():
	queue_free()
func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0 
		die() 
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("test_damage"):
		take_damage(5)
		print("Current health: %d" % current_health)
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
	if Input.is_action_just_pressed("Swing"):
		sword.show()
		await get_tree().create_timer(0.2).timeout
		sword.hide()
	if velocity.x > 0:
		sprite_2d.flip_h = false
		sword.scale.x = -3.031
		sword.scale.y = -3.27
		sword.position 
	else: 
		sprite_2d.flip_h = true
		sword.scale.x = 3.031
		sword.scale.y = 3.027

	move_and_slide()
func start_dash(direction: Vector2):
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = direction
	cooldown_timer.stop()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mob:
		if dmgcool.is_stopped():
			take_damage(10)
			print("Current health: %d" % current_health)
			dmgcool.start()
		
func do_dmg():
	pass
