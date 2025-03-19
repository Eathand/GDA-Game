extends CharacterBody2D
class_name Mob
@export var max_health := 100
#@onready var player: Player = null
@export var max_speed := 650.0
var acceleration = 700
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

var current_health := max_health
#func _ready() -> void:
	##if player == null:
		##player = get_node("Game/Player")
	##if player == null:
		##print("jjjjaaa")
func _physics_process(delta: float) -> void:

	var direction = global_position.direction_to(get_global_player_position())
	var distance = global_position.distance_to(get_global_player_position())
	var speed = max_speed if distance > 100 else max_speed * distance / 100
	var desired_velocity = direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
func die():
	queue_free()

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0 
		die() 

func get_global_player_position() -> Vector2:
	var Plaayer = get_tree().root.get_node_or_null("Game/Player")
	if Plaayer:
		return Plaayer.global_position
	else:
		printerr("koda")
		return global_position 
