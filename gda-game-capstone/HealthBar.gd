extends TextureProgressBar

@export var playerr: Player
@onready var player: Player = $"../../Player"
@onready var progress_bar: TextureProgressBar = $"."



func _ready():
	if player:
		update_health_bar(player.Health_changed.connect(update_health_bar))
		progress_bar.max_value = player.max_health
		progress_bar.value = player.current_health

func update_health_bar(value):
	progress_bar.value = value
	print('my health is:', progress_bar.value)
