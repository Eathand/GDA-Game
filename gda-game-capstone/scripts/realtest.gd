extends Node2D
@onready var canvas_layer: Control = $CanvasLayer/Control
var pause = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauuse()
func pauuse():
	if pause:
		canvas_layer.hide()
		Engine.time_scale = 1
	else:
		canvas_layer.show()
		Engine.time_scale = 0
	pause = !pause
