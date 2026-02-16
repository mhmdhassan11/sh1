extends Control

@onready var _cards: GridContainer = $MainVBox/GridCenter/CardsContainer
@onready var _back_btn: TextureButton = $MainVBox/BackButton

func _ready():
	_update_labels()
	_setup_animations()

func _setup_animations():
	for card in _cards.get_children():
		card.pivot_offset = card.size * 0.5
		var btn := card.get_node("Button") as Button
		btn.button_down.connect(_on_card_down.bind(card))
		btn.button_up.connect(_on_card_up.bind(card))
	_back_btn.pivot_offset = _back_btn.size * 0.5
	_back_btn.button_down.connect(_on_card_down.bind(_back_btn))
	_back_btn.button_up.connect(_on_card_up.bind(_back_btn))

func _on_card_down(node: Control):
	AudioManager.play_button_click()
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(node, "scale", Vector2(0.95, 0.95), 0.1)

func _on_card_up(node: Control):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(node, "scale", Vector2.ONE, 0.2)

func _update_labels():
	for card in _cards.get_children():
		var world_name: String = card.name.replace("Card", "").to_lower()
		if GameManager.worlds.has(world_name):
			var label := card.get_node("LevelProgress") as Label
			label.text = str(GameManager.world_progress[world_name]) + "/" + str(GameManager.worlds[world_name].size())

func _on_forest_pressed(): _start_world("forest")
func _on_farm_pressed(): _start_world("farm")
func _on_ocean_pressed(): _start_world("ocean")
func _on_city_pressed(): _start_world("city")

func _start_world(world_name: String):
	GameManager.current_world = world_name
	GameManager.current_level = 0
	ScreenManager.change_scene("res://scenes/game_screen.tscn")

func _on_back_pressed():
	AudioManager.play_button_click()
	var tw = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(_back_btn, "scale", Vector2(0.9, 0.9), 0.1)
	tw.tween_property(_back_btn, "scale", Vector2.ONE, 0.1)
	await tw.finished
	get_tree().quit()
