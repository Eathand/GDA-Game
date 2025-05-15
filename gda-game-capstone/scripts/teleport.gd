extends Area2D

@export var new_position_x: int
@export var new_position_y: int

@onready var regular_bgm: AudioStreamPlayer2D = $"../Player/RegularBGM"
@onready var calm_bgm: AudioStreamPlayer2D = $"../Player/CalmBGM"
@onready var boss_bgm: AudioStreamPlayer2D = $"../Player/BossBGM"


@export var song_type: AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.position.x = new_position_x
		body.position.y = new_position_y
	print(song_type)
	if song_type == null: pass 
	else:
		regular_bgm.stop()
		calm_bgm.stop()
		boss_bgm.stop()
		song_type.play()
