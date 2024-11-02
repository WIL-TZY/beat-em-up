extends Camera3D

var smooth := 4
var initial_pos := -17.5
var clamped_pos := -10.5
@onready var player: Player = %Player

func _process(delta: float) -> void:
	# So the camera doesn't move back, only forward
	if position.x < player.position.x:
		# Camera movement follows the player
		position.x = lerp(position.x, player.position.x, smooth * delta)
		
		# Limit camera borders
		position.x = clamp(position.x, initial_pos, clamped_pos)
