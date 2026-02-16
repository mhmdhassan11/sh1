extends Control

signal resume_game

func _ready():
	_setup_buttons()

func _setup_buttons():
	var buy_btn = $Center/Panel/VBox/BuyButton
	var continue_btn = $Center/Panel/VBox/ContinueButton
	
	buy_btn.pivot_offset = buy_btn.size * 0.5
	continue_btn.pivot_offset = continue_btn.size * 0.5
	
	buy_btn.button_down.connect(_on_down.bind(buy_btn))
	buy_btn.button_up.connect(_on_up.bind(buy_btn))
	continue_btn.button_down.connect(_on_down.bind(continue_btn))
	continue_btn.button_up.connect(_on_up.bind(continue_btn))

func _on_down(btn: Control):
	AudioManager.play_button_click()
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(btn, "scale", Vector2(0.9, 0.9), 0.1)

func _on_up(btn: Control):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(btn, "scale", Vector2.ONE, 0.2)

func _on_buy_pressed():
	OS.shell_open("https://mhmd-hasan.itch.io/shadow-match")

func _on_continue_pressed():
	emit_signal("resume_game")
	queue_free()
