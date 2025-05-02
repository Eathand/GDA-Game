extends CharacterBody2D
class_name Boss
@export var speed = 210
@export var rangee = 200
@export var atkcdtime = 2
@export var atkdmg = 10
@export var max_health: int = 100
@export var slash_scene: PackedScene


var player = Node2D
var atkcd = 0
var current_health:= max_health
var is_attacking: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Area2D = $attack


func _physics_process(delta: float) -> void:
	if player == null:
		return
	atkcd = max(0.0, atkcd - delta)
	var distance = global_position.distance_to(player.global_position)
	#var direction = (player.global_position - global_position).normalized()
	if is_attacking:
		velocity = Vector2.ZERO
	else:
		
		if distance > rangee:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		#move_and_slide()
		#animtion player 
		else:
			velocity = Vector2.ZERO
		#move_and_slide()
			if atkcd <= 0.0:
				start_attack()
	move_and_slide()
	atkcd -= delta

func _ready() -> void:
	animated_sprite_2d.play("idle")
	player = get_tree().get_first_node_in_group("player") as Node2D
	attack.body_entered.connect(on_attack_hit)
	attack.monitoring = false

func on_attack_hit(body: Node):
		if body is Player:
			if body.dmgcool.is_stopped():
				body.take_damage(atkdmg)
				body.dmgcool.start()
				print(body.current_health)
func start_attack():
	is_attacking = true
	atkcd = atkcdtime
	#windup
	animated_sprite_2d.play("attack2")
	attack_slash()
	attack.monitoring = true
	await get_tree().create_timer(1).timeout
	attack_slash()
	await get_tree().create_timer(1).timeout
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
	slash.position.x = self.position.x -150
	slash.position.y = self.position.y +20
	slash.direction = dir
	slash.rotation = dir.angle()


func _on_attack_body_entered(body: Node2D) -> void:
	pass
func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0 
		die() 
