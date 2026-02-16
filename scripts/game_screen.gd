extends Control

var _dragging: Control = null
var _drag_offset := Vector2.ZERO
var _original_positions := {}
var _matched := 0
var _total := 3
var _snap_dist_sq := 10000.0  # 100^2, avoid sqrt in distance check

@onready var _object_container: HBoxContainer = $GameBoard/VBox/ObjectArea/ObjectContainer
@onready var _shadow_container: HBoxContainer = $GameBoard/VBox/ShadowArea/ShadowContainer
@onready var _drag_layer: Control = $DragLayer
@onready var _particles: CPUParticles2D = $SuccessParticles
@onready var _stars_label: Label = $TopBar/HBox/StarsBox/StarsLabel
@onready var _hearts_label: Label = $TopBar/HBox/HeartsBox/HeartsLabel
@onready var _level_label: Label = $TopBar/HBox/LevelLabel
@onready var _bg: TextureRect = $Background

const GOLD_STAR := preload("res://assets/goldstar.webp")

func _ready():
	_setup_level()

	# Wait for layout to settle
	await get_tree().process_frame
	await get_tree().process_frame
	for child in _object_container.get_children():
		_original_positions[child.name] = child.global_position
		child.gui_input.connect(_on_object_input.bind(child))

func _setup_level():
	var data = GameManager.get_current_level_data()
	if data == null:
		ScreenManager.change_scene("res://scenes/world_selection.tscn")
		return
	_bg.texture = load(GameManager.get_world_background())
	_level_label.text = "Level " + str(GameManager.current_level + 1)
	var objects := _object_container.get_children()
	var shadows := _shadow_container.get_children()
	var shuffled = data.duplicate()
	shuffled.shuffle()
	for i in objects.size():
		objects[i].texture = load(GameManager.get_object_texture(shuffled[i]))
		shadows[i].texture = load(GameManager.get_shadow_texture(data[i]))
		objects[i].name = shuffled[i]
		shadows[i].name = data[i]
	_update_ui()

func _update_ui():
	_stars_label.text = str(GameManager.total_stars)
	_hearts_label.text = str(GameManager.total_hearts)

func _input(event: InputEvent):
	if _dragging == null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_try_snap(_dragging)
			_dragging = null
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion:
		_dragging.global_position = event.global_position + _drag_offset
		get_viewport().set_input_as_handled()

func _on_object_input(event: InputEvent, obj: Control):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_dragging = obj
		_drag_offset = obj.global_position - event.global_position
		var gp := obj.global_position
		obj.reparent(_drag_layer)
		obj.global_position = gp
		obj.z_index = 10

func _try_snap(obj: Control):
	var target: Control = null
	for shadow in _shadow_container.get_children():
		if shadow.name == obj.name:
			target = shadow
			break
	if target == null:
		_return_to_original(obj)
		return
	var tc := target.global_position + target.size * 0.5
	var oc := obj.global_position + obj.size * 0.5
	# Use squared distance to avoid sqrt
	if oc.distance_squared_to(tc) < _snap_dist_sq:
		_on_match(obj, target)
	else:
		AudioManager.play_fail()
		_shake(obj)
		_return_to_original(obj)

func _on_match(obj: Control, shadow: Control):
	obj.global_position = shadow.global_position
	obj.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_matched += 1
	AudioManager.play_success()
	# Particles
	_particles.global_position = shadow.global_position + shadow.size * 0.5
	_particles.restart()
	_particles.emitting = true
	# Object pop
	var tw := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(obj, "scale", Vector2(1.2, 1.2), 0.15)
	tw.tween_property(obj, "scale", Vector2.ONE, 0.15)
	# Shadow flash
	shadow.modulate = Color(0.5, 1.0, 0.5)
	var stw := create_tween()
	stw.tween_property(shadow, "scale", Vector2(1.1, 1.1), 0.1)
	stw.tween_property(shadow, "scale", Vector2.ONE, 0.1)
	stw.tween_property(shadow, "modulate", Color(0.4, 0.9, 0.4, 0.9), 0.2)
	# Star animation
	var star := get_node_or_null("TopBar/HBox/Stars/Star" + str(_matched))
	if star:
		var star_tw := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		star_tw.tween_property(star, "scale", Vector2(1.5, 1.5), 0.2)
		star_tw.tween_callback(func(): star.texture = GOLD_STAR)
		star_tw.tween_property(star, "scale", Vector2.ONE, 0.3)
	if _matched >= _total:
		_on_level_complete()

func _shake(obj: Control):
	var tw := create_tween()
	obj.modulate = Color(1.0, 0.4, 0.4)
	var pos := obj.global_position
	for i in 3:
		tw.tween_property(obj, "global_position", pos + Vector2(10, 0), 0.04)
		tw.tween_property(obj, "global_position", pos - Vector2(10, 0), 0.04)
	tw.tween_property(obj, "global_position", pos, 0.04)
	tw.tween_property(obj, "modulate", Color.WHITE, 0.15)

func _return_to_original(obj: Control):
	if _original_positions.has(obj.name):
		create_tween().tween_property(obj, "global_position", _original_positions[obj.name], 0.2).set_ease(Tween.EASE_OUT)

func _on_level_complete():
	GameManager.complete_current_level()
	GameManager.total_stars += 1
	GameManager.total_hearts += 1
	_update_ui()
	await get_tree().create_timer(0.8).timeout
	ScreenManager.change_scene("res://scenes/level_complete.tscn")

func _on_back_pressed():
	AudioManager.play_button_click()
	var btn = $BackButton
	var tw = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(btn, "scale", Vector2(0.9, 0.9), 0.1)
	tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	await tw.finished
	ScreenManager.change_scene("res://scenes/world_selection.tscn")
