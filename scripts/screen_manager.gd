extends CanvasLayer

var _rect: ColorRect
var _transitioning := false

func _ready():
	layer = 100
	_rect = ColorRect.new()
	_rect.color = Color.TRANSPARENT
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rect)

func change_scene(scene_path: String) -> void:
	if _transitioning:
		return
	_transitioning = true
	_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	# Fade out
	var tw := create_tween()
	tw.tween_property(_rect, "color:a", 1.0, 0.35)
	await tw.finished
	get_tree().change_scene_to_file(scene_path)
	# Fade in
	tw = create_tween()
	tw.tween_property(_rect, "color:a", 0.0, 0.35)
	await tw.finished
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_transitioning = false
