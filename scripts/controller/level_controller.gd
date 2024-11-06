class_name LevelController extends BaseScene

@onready var HUD: UI = $HUD

var enemies := 0
var unlocked_at_area := 0.0
var last_area : bool = false

func _ready() -> void:
	super()

func enemy_died() -> void:
	enemies -= 1
	
	if last_area: 
		# Ends the game if level is cleared
		HUD.__level_cleared()
		return
		
	if enemies <= 0:
		HUD.__show_go()
		_next_area(unlocked_at_area)

func _next_area(camera_limit: float) -> void:
	GameController.camera.set_camera_limit(camera_limit)

func config_next_area(amount: int, unlocked: float) -> void:
	enemies = amount
	unlocked_at_area = unlocked
