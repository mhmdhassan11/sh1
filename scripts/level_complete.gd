extends Control

@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _confetti_l: CPUParticles2D = $ConfettiLeft
@onready var _confetti_r: CPUParticles2D = $ConfettiRight

func _ready():
	_update_confetti()
	get_tree().root.size_changed.connect(_update_confetti)
	AudioManager.play_level_complete()
	_anim.play("celebrate")
	_setup_buttons()

func _update_confetti():
	var vs := get_viewport_rect().size
	_confetti_l.position = Vector2(0, vs.y * 0.75)
	_confetti_r.position = Vector2(vs.x, vs.y * 0.75)

func _setup_buttons():
	var buttons := [$Center/VBox/Buttons/NextButton, $Center/VBox/Buttons/ReplayButton]
	for btn in buttons:
		btn.pivot_offset = btn.size * 0.5
		btn.button_down.connect(_on_down.bind(btn))
		btn.button_up.connect(_on_up.bind(btn))

func _on_down(btn: Control):
	AudioManager.play_button_click()
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(btn, "scale", Vector2(0.9, 0.9), 0.1)

func _on_up(btn: Control):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(btn, "scale", Vector2.ONE, 0.2)

func _on_next_pressed():
	AdManager.show_interstitial()
	if GameManager.next_level():
		ScreenManager.change_scene("res://scenes/game_screen.tscn")
	else:
		ScreenManager.change_scene("res://scenes/world_selection.tscn")

func _on_replay_pressed():
	ScreenManager.change_scene("res://scenes/game_screen.tscn")
