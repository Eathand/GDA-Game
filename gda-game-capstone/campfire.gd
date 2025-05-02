extends Area2D

@export var heal_amount: int = 1000

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("heal"):
		body.heal(heal_amount)
