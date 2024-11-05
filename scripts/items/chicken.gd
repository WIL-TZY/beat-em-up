class_name Item extends Area3D

@export var energy := 50.0

func _on_body_entered(player: Player) -> void:
	#body.item = self
	player.__on_item_picked.emit(self)

#func _on_body_exited(body: Node3D) -> void:
	#if body.name.match("Player"):
		#body.item = null

func pickup() -> float:
	return energy
