extends Area2D
class_name PlayerSlash
@onready var damage: int = 20
@onready var speed: float = 1000.0
@export var life: float = 10.0
var dirdirdir = true
@onready var sprite_2d: Sprite2D = $Sprite2D
var direction: Vector2 = Vector2.RIGHT
@onready var projectile_sound: AudioStreamPlayer2D = $ProjectileSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	await get_tree().create_timer(life).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dirdirdir:
		position += direction.normalized() * speed * delta
		sprite_2d.flip_h = true
	else:
		position -= direction.normalized() * speed * delta
		sprite_2d.flip_h = false


func _on_body_entered(body: Node2D) -> void:
	if body is Boss:
		body.take_damage(damage)
		print("bosshealth is", body.current_health)
		projectile_sound.play()
	if body is Mob:
		body.take_damage(damage)
		projectile_sound.play()
		print("mobhealth is ", body.current_health)
		
func dirdir(num):
	if num > 0:
		dirdirdir = false
	else:
		dirdirdir = true
