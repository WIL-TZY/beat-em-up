extends Area3D

# Only collides with player
func _on_body_entered(player: Player) -> void:
	player.__take_damage(10)
