extends Node

var is_demo: bool = false
var current_world := "farm"
var current_level := 0
var total_stars := 0
var total_hearts := 0

var world_progress := {
	"farm": 0,
	"forest": 0,
	"ocean": 0,
	"city": 0
}

var worlds := {
	"farm": [
		["cow", "sheep", "duck"],
		["checen", "donkey", "goat"],
		["horse", "roster", "wez"],
		["a", "b", "c"],
		["d", "e", "f"],
		["g", "h", "i"],
		["j", "k", "l"],
		["m", "n", "o"],
		["p", "q", "r"],
		["s", "t", "u"]
	],
	"forest": [
		["ban", "bat", "bond"],
		["cro", "dob", "ele"],
		["fah", "fox", "fro"],
		["gaz", "graf", "heb"],
		["kang", "khan", "lio"],
		["monk", "moo", "owl"],
		["paro", "qon", "qond"],
		["qua", "sheta", "snak"],
		["sq", "tig", "tur"],
		["wah", "za", "zeb"]
	],
	"ocean": [
		["aboz", "dolf", "fell"],
		["fgm", "gmbry", "gnh"],
		["gwasa", "help", "hobhr"],
		["hot", "kapo", "klp"],
		["knz", "loly", "mnsh"],
		["mtr", "nemo", "nf5"],
		["ngm", "o5t", "qndel"],
		["qrsh", "s3b", "saro5"],
		["sh3b", "shok", "sm9"],
		["smkazrq", "sta", "sulhf"]
	],
	"city": [
		["3ag", "3mod", "bus"],
		["car", "deka", "es3af"],
		["esha", "garp", "gaz"],
		["holo", "hos", "hosp"],
		["mail", "matt", "meza"],
		["moto", "nafo", "nattah"],
		["plan", "polic", "pr"],
		["qatr", "qort", "scool"],
		["shop", "soper", "stop"],
		["t1", "tax", "tms"]
	]
}

func get_current_level_data() -> Variant:
	var w = worlds.get(current_world)
	if w and current_level < w.size():
		return w[current_level]
	return null

func next_level() -> bool:
	var w = worlds.get(current_world)
	if w and current_level + 1 < w.size():
		current_level += 1
		return true
	return false

func get_world_background() -> String:
	return "res://assets/game.webp"

func get_object_texture(obj_name: String) -> String:
	return "res://assets/%s/%s.webp" % [current_world, obj_name]

func get_shadow_texture(obj_name: String) -> String:
	return "res://assets/%s/%sshadow.webp" % [current_world, obj_name]

func complete_current_level():
	if current_level >= world_progress[current_world]:
		world_progress[current_world] = current_level + 1
