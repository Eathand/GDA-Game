extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $ParallaxBackground/trees/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start screen ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.play("res://Fire.tscn")
