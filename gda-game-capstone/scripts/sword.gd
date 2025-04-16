extends Node2D
class_name Sword

@onready var slashh: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mob and (area_2d.visible == true):
		body.take_damage(5)
		print(body.current_health)
		

func swing():
	if Input.is_action_just_pressed("Swing"):
		slashh.play("swingg")
		animation_player.play("swing")
		await animation_player
