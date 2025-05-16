extends CharacterBody2D
class_name Boss
@export var speed = 210
@export var rangee = 100
@export var atkcdtime = 2
@export var atkdmg = 10
@export var max_health: int = 100
@export var slash_scene: PackedScene
@export var mega_attack_scene: PackedScene
@export var close_range = 100
var boss_position = $".".global_position.x
@onready var player = get_node("realtest/Player")
var atkcd = 0
var current_health:= max_health
var is_attacking: bool = false
@onready var mega_atk_timer: Timer = Timer.new()
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Area2D = $attack
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mega_attack: Area2D = $mega_attack

var is_dead = false
var has_phase2_started := false
var mega_cd := 15
var can_mega := true
var is_doing_mega_atk := false
func _physics_process(delta: float) -> void:
	if is_dead or is_doing_mega_atk:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if not is_dead:
		if velocity.x > 0:
			animated_sprite_2d.flip_h = true
		if velocity.x < 0:
			animated_sprite_2d.flip_h = false
		if player == null:
			return
		if is_attacking:
			return
		atkcd = max(0.0, atkcd - delta)
		var distance = global_position.distance_to(player.global_position)
		if distance <= rangee:
			face_player()
			melee_attack()
		if is_attacking:
			velocity = Vector2.ZERO
		else:
			
			if distance > rangee:
				var direction = (player.global_position - global_position).normalized()
				velocity = direction * speed
				if atkcd <= 0.0:
					start_attack()
			else:
				velocity = Vector2.ZERO
		move_and_slide()


func _ready() -> void:
	mega_atk_timer.wait_time = 10.0
	mega_atk_timer.one_shot = false
	mega_atk_timer.autostart = false
	mega_atk_timer.connect("timeout", Callable(self, "the_attack"))
	add_child(mega_atk_timer)
	animated_sprite_2d.play("idle")
	player = get_tree().get_first_node_in_group("player") as Node2D
	attack.body_entered.connect(on_attack_hit)
	attack.monitoring = false
	mega_attack.body_entered.connect(_on_mega_attack_body_entered)
	mega_attack.monitoring = false
func on_attack_hit(body: Node):
		if body is Player:
			if body.dmgcool.is_stopped():
				body.take_damage(atkdmg)
				body.dmgcool.start()
func start_attack():
	is_attacking = true
	atkcd = atkcdtime
	animated_sprite_2d.play("attack2")
	#attack_slash()
	attack.monitoring = true
	await get_tree().create_timer(0.6153846153846154).timeout
	attack_slash()
	await get_tree().create_timer(0.3846153846153846).timeout
	attack.monitoring = false
	animated_sprite_2d.play("idle")
	is_attacking = false
func die() -> void:
	queue_free()
func attack_slash() -> void:
	var slash = slash_scene.instantiate()
	get_parent().add_child(slash)
	slash.global_position = global_position
	var dir = (player.global_position - global_position).normalized()
	if velocity.x > 0:
		slash.position.x = self.position.x +150
		slash.position.y = self.position.y +20
	else:
		slash.position.x = self.position.x -150
		slash.position.y = self.position.y +20
	slash.direction = dir
	slash.rotation = dir.angle()
func melee_attack():
	is_attacking = true 
	attack.monitoring = true
	animated_sprite_2d.play("attack1")
	animation_player.play("melee")
	await get_tree().create_timer(1.0).timeout
	attack.monitoring = false
	is_attacking = false
func _on_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(50)
		body.dmgcool.start()
	
		print(body.current_health)
func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0 
		die_animation()
	if current_health <= max_health / 2 and not has_phase2_started:
		print("CHECKING")
		has_phase2_started = true
		start_phase2()
func face_player():
	var dir = player.global_position.x - global_position.x 
	animated_sprite_2d.flip_h = dir > 0
func die_animation():
		is_dead = true
		animated_sprite_2d.play("death")
		await animated_sprite_2d.animation_finished
		queue_free()
		
func start_phase2():
	print("KEKQ")
	mega_atk_timer.start()
func the_attack():
	print("fewkjnf")
	if not is_instance_valid(get_tree().get_first_node_in_group("player")):
		return
	is_doing_mega_atk = true
	var player = get_tree().get_first_node_in_group("player")
	var target_position = player.global_position
	var offset = Vector2(-50,0)
	if animated_sprite_2d.flip_h:
		offset.x *= -1
	animated_sprite_2d.play("tele_in")
	await animated_sprite_2d.animation_finished
	self.position = player.global_position
	mega_attack.monitoring = true
	
	animation_player.play("big_attack")
	animated_sprite_2d.play("mega_attack")
	animated_sprite_2d.scale.x = 8
	animated_sprite_2d.scale.y = 8
	await animated_sprite_2d.animation_finished
	mega_attack.monitoring = false
	mega_attack.global_position = target_position + offset
	get_parent().add_child(attack)
	
	animated_sprite_2d.play("tele_out")
	animated_sprite_2d.scale.x = 1
	animated_sprite_2d.scale.y = 1
	await animated_sprite_2d.animation_finished
	is_doing_mega_atk = false
	


func _on_mega_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.dmgcool.is_stopped():
			body.take_damage(100)
			body.dmgcool.start()
			print("WORKS:", body.current_health)
