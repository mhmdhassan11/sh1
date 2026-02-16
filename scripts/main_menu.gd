extends Control

@onready var _btn: TextureButton = $VBox/PlayButton

func _ready():
	AdManager.show_banner()
	_btn.pivot_offset = _btn.size * 0.5
	_btn.button_down.connect(_on_down)
	_btn.button_up.connect(_on_up)

func _on_down():
	AudioManager.play_button_click()
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(_btn, "scale", Vector2(0.9, 0.9), 0.1)

func _on_up():
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(_btn, "scale", Vector2.ONE, 0.2)

func _on_play_button_pressed():
	ScreenManager.change_scene("res://scenes/world_selection.tscn")
