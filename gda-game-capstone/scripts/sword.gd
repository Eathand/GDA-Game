extends Node2D
class_name Sword

@onready var slashh: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Swing"):
		slashh.play("swingg")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mob:
		body.take_damage(5)
		print(body.current_health)
