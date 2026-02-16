extends Node

# AdMob IDs
var app_id := "ca-app-pub-2194827397743106~4819006311"
var banner_id := "ca-app-pub-2194827397743106/1585981464"
var interstitial_id := "ca-app-pub-2194827397743106/1779329259"
var rewarded_id := "ca-app-pub-2194827397743106/5292023262"

var admob = null
var test_mode := false

func _ready():
	_initialize_admob()

func _initialize_admob():
	if Engine.has_singleton("AdMob"):
		admob = Engine.get_singleton("AdMob")
		admob.initialize(test_mode, 0) # 0 for Mixed, 1 for Games, 2 for Family
		print("AdMob: Initialized.")
		_load_ads()
	else:
		print("AdMob: Plugin not found. Ads disabled.")

func _load_ads():
	if admob:
		admob.load_banner(banner_id, true) # true for top, false for bottom
		admob.load_interstitial(interstitial_id)
		admob.load_rewarded_video(rewarded_id)

func show_banner():
	if admob:
		admob.show_banner()
	else:
		print("AdMob Mock: Showing Banner")

func hide_banner():
	if admob:
		admob.hide_banner()

func show_interstitial():
	if admob:
		if admob.is_interstitial_loaded():
			admob.show_interstitial()
			admob.load_interstitial(interstitial_id) # Reload for next time
		else:
			print("AdMob: Interstitial not loaded.")
			admob.load_interstitial(interstitial_id)
	else:
		print("AdMob Mock: Showing Interstitial")

func show_rewarded():
	if admob:
		if admob.is_rewarded_video_loaded():
			admob.show_rewarded_video()
			admob.load_rewarded_video(rewarded_id)
		else:
			print("AdMob: Rewarded not loaded.")
			admob.load_rewarded_video(rewarded_id)
	else:
		print("AdMob Mock: Showing Rewarded Video")
