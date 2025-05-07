extends ProgressBar

@export var player: Player



func _ready():
	if player:
		player.Health_changed.connect(update_health_bar)
		update_health_bar()


func update_health_bar():
	value = player.current_health * 100 / player.max_health 
