extends Control

func _ready():
	AudioManager.play_level_complete()
	_setup_buttons()

func _setup_buttons():
	var buy_btn = $Center/VBox/Buttons/BuyButton
	var menu_btn = $Center/VBox/Buttons/MenuButton
	
	buy_btn.pivot_offset = buy_btn.size * 0.5
	menu_btn.pivot_offset = menu_btn.size * 0.5
	
	buy_btn.button_down.connect(_on_down.bind(buy_btn))
	buy_btn.button_up.connect(_on_up.bind(buy_btn))
	menu_btn.button_down.connect(_on_down.bind(menu_btn))
	menu_btn.button_up.connect(_on_up.bind(menu_btn))

func _on_down(btn: Control):
	AudioManager.play_button_click()
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(btn, "scale", Vector2(0.9, 0.9), 0.1)

func _on_up(btn: Control):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(btn, "scale", Vector2.ONE, 0.2)

func _on_buy_pressed():
	OS.shell_open("https://mhmd-hasan.itch.io/shadow-match")

func _on_menu_pressed():
	ScreenManager.change_scene("res://scenes/world_selection.tscn")
