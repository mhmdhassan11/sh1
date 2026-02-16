extends Control

@onready var _anim: AnimationPlayer = $AnimationPlayer

func _ready():
	_anim.play("logo_bounce")

func _on_timer_timeout():
	ScreenManager.change_scene("res://scenes/main_menu.tscn")
