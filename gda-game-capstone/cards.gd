extends Control
signal buff_selected(buff_name: String)

var buff_name: String
var description: String
var apply_func: Callable
@onready var card_texture: TextureRect = $Image
var texture_path: String

func _ready():
	$Label.text = buff_name
	$RichTextLabel.text = description
	if texture_path != '':
		card_texture.texture = load(texture_path)
		print("Card ready:", buff_name)

func _on_image_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		print("uhh eayeyhahdhh")
		apply_func.call()
		buff_selected.emit(buff_name)
		Engine.time_scale = 1
