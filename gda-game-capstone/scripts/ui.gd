extends Control
@onready var resume_button: Button = $"Resume Button"
@onready var menu_button: Button = $"Menu Button"
@onready var quit_button: Button = $"Quit Button"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		


func _on_resume_button_pressed() -> void:
	self.hide()
	Engine.time_scale = 1


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	Engine.time_scale =1
	Transition.load_scene("res://start_screen.tscn")
