extends Node

# Audio pool - reuse players instead of creating/destroying per sound
const POOL_SIZE := 4
var _pool: Array[AudioStreamPlayer] = []
var _sounds := {}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Preload all sounds once
	_sounds = {
		&"btn_click": preload("res://assets/sound/button-click(chosic.com).mp3"),
		&"success": preload("res://assets/sound/mixkit-winning-a-coin-video-game-2069.wav"),
		&"fail": preload("res://assets/sound/mixkit-player-losing-or-failing-2042.wav"),
		&"level_complete": preload("res://assets/sound/mixkit-completion-of-a-level-2063.wav")
	}
	# Pre-create audio players pool
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_pool.append(p)

func _get_free_player() -> AudioStreamPlayer:
	for p in _pool:
		if not p.playing:
			return p
	# All busy — reuse oldest (first in pool)
	return _pool[0]

func play(sound_name: StringName) -> void:
	var stream = _sounds.get(sound_name)
	if stream:
		var p := _get_free_player()
		p.stream = stream
		p.play()

func play_button_click() -> void:
	play(&"btn_click")

func play_success() -> void:
	play(&"success")

func play_fail() -> void:
	play(&"fail")

func play_level_complete() -> void:
	play(&"level_complete")
