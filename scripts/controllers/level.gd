class_name Level extends Scene

## This controller handles connection between nodes in the level scene

static var debug_enemies: Array[Enemy] # For debug

@export var _player: Player 
@export var _camera: Camera3D
@export var _HUD: UI

# Static variables persist across instances and scene changes
# ideal for global data management, utility functions, and ensuring a single data copy 
# These variables can be accessed directly from the class without creating a new instance
static var player: Player 
static var camera: Camera3D
static var HUD: UI

var enemies := 0
var unlocked_at_area := 0.0
var last_area : bool = false

# Runs before ready
func _enter_tree() -> void:
	Global.level = self
	
	player = _player
	camera = _camera
	HUD = _HUD

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
	Global.level.camera.set_camera_limit(camera_limit)

func config_next_area(amount: int, unlocked: float) -> void:
	enemies = amount
	unlocked_at_area = unlocked
