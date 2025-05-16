extends Area2D
class_name BossSlash
@onready var damage: int = 10
@onready var speed: float = 1500.0
@export var life: float = 2.0
var direction: Vector2 = Vector2.RIGHT
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	await get_tree().create_timer(life).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta


func _on_body_entered(body: Node) -> void:
	if body is Player and body.dmgcool.is_stopped():
		body.take_damage(damage)
		body.dmgcool.start()
		print(body.current_health)
