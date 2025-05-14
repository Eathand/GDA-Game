extends CharacterBody2D
class_name Player
signal dir_slash(ans)
var speed := 300
@export var max_health := 10000
@onready var dmgcool: Timer = $DamageCooldown
@onready var sprite_2d: Sprite2D = $root/Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $"../HealthBar/ProgressBar"
signal Health_changed(current_health)
@onready var playercol = $"."
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword: Sword = $root/Sword
@export var acceleration := 1000000
@export var deceleration := 1000000
@export var dash_speed := 1500.0
@export var dash_duration := .2
@export var dash_cooldown := 1.5
@export var projectile_scene: PackedScene
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
	get_tree().change_scene_to_file("res://DeathMenu.tscn")
func take_damage(amount: int):
	current_health -= amount
	progress_bar.value = current_health
	if current_health <= 0:
		current_health = 0
		die()
	
func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	print("Healed! Current health: %d" % current_health)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		projectile()
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
			animated_sprite_2d.play("walk")
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			animated_sprite_2d.stop()
		if Input.is_action_just_pressed("dash") and has_input_direction and cooldown_timer.is_stopped():
			start_dash(direction)
			if Input.is_action_pressed("up"):
				animated_sprite_2d.play("Ndash")
				animated_sprite_2d.flip_h = false
			else:
				animated_sprite_2d.play("daash")
				animated_sprite_2d.flip_h = false
			if Input.is_action_pressed("down"):
				animated_sprite_2d.play("Sdash")
				animated_sprite_2d.flip_h = false
			if Input.is_action_pressed("up") and Input.is_action_pressed("left"):
				animated_sprite_2d.play("NWdash")
				animated_sprite_2d.flip_h = false
			if Input.is_action_pressed("down") and Input.is_action_pressed("left"):
				animated_sprite_2d.play("SWdash")
				animated_sprite_2d.flip_h = false
			if Input.is_action_pressed("up") and Input.is_action_pressed("right"):
				animated_sprite_2d.play("NWdash")
				animated_sprite_2d.flip_h = true
			if Input.is_action_pressed("down") and Input.is_action_pressed("right"):
				animated_sprite_2d.play("SWdash")
				animated_sprite_2d.flip_h = true
		else:
			playercol.set_collision_mask_value(3, true)


	flip_sword()
	move_and_slide()
	
func flip_sword():
	if Input.is_action_just_pressed("Swing"):
		sword.show()
		sword.area_2d.show()
		sword.swing()
		await get_tree().create_timer(0.2).timeout
		sword.hide()
		sword.area_2d.hide()
	if Input.is_action_pressed("right"):
		animated_sprite_2d.flip_h = true
		sword.position.x = -10
		sword.scale.x =3
		sword.scale.y=3
		send_signal()
	if Input.is_action_pressed("left"):
		animated_sprite_2d.flip_h = false
		sword.position.x = 10
		sword.scale.x =3
		sword.scale.y=-3
		send_signal()
func start_dash(direction: Vector2):
	playercol.set_collision_mask_value(3, false)
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = direction
	cooldown_timer.stop()
	#playercol.disabled = false
func projectile():

	var player_slash = projectile_scene.instantiate()
	get_parent().add_child(player_slash)
	player_slash.global_position = global_position
	player_slash.direction = Vector2.RIGHT
	player_slash.dirdir(0 if animated_sprite_2d.flip_h else 1)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Mob):
		if dmgcool.is_stopped():
			take_damage(10)
			print("Current health: %d" % current_health)
			dmgcool.start()
		Health_changed.emit(current_health)
func do_dmg():
	pass
func send_signal():
	if animated_sprite_2d.flip_h == true:
		dir_slash.emit(1)
	else:
		dir_slash.emit(0)
