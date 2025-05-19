extends Control
@export var buff_card_scene: PackedScene
func _ready():
	Engine.time_scale = 0
	var all_buffs = [
		{name="Max HP Boost", desc="Increase max HP by 20%", apply=func(): apply_max_hp(), texture="res://assets/maxhhealth.png"},
		{name="Speed Boost", desc="Move 20% faster", apply=func(): apply_speed(), texture="res://assets/moveeeemeeeeent.png" },
		{name="Attack Cooldown", desc="Sword attacks cooldown reduced", apply=func(): apply_attack_cooldown(), texture="res://assets/attackspeeed1213.png" },
		{name="Projectile Cooldown", desc="Projectile cooldown reduced", apply=func(): apply_proj_cooldown(), texture="res://assets/attacskpeeed.png" }
	]
	all_buffs.shuffle() 
	var selected_buffs = all_buffs.slice(0, 3) 
	for i in range(3):
		var card = buff_card_scene.instantiate()
		card.buff_name = selected_buffs[i].name
		card.description = selected_buffs[i].desc
		card.apply_func = selected_buffs[i].apply
		card.texture_path = selected_buffs[i].texture
		card.position = Vector2(100 + i * 550, 200)
		card.buff_selected.connect(_on_buff_selected)
		add_child(card)
func _on_buff_selected(buff_name):
	print("Player selected: ", buff_name)
	queue_free() 
func apply_max_hp():
	var player = get_node("/root/Realtest/Player")
	player.max_health *= 1.2
	player.current_health *= 1.2
	player.progress_bar.max_value = player.max_health
	player.progress_bar.value = player.current_health
	print("cccuurent hP:", player.current_health)
func apply_speed():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.speed += 200  
		print("Speedd: ", player.speed)
func apply_attack_cooldown():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.sword_timer.wait_time = max(player.sword_timer.wait_time - 0.1, 0.1)
		print("Sword cooldown:", player.sword_timer.wait_time)
func apply_proj_cooldown():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.projectile_timer.wait_time = max(player.projectile_timer.wait_time - 2.1, 0.1)
		print("Projectile cool:", player.projectile_timer.wait_time)
