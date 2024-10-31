class_name HealthComponent extends Node

var hp : float
var dead : bool

signal __on_damage(hp)
signal __on_dead

func __take_damage(damage: float) -> void:
	if dead: return

	# Reduce HP
	hp -= damage
	
	# Death Check
	if hp <= 0:
		dead = true
		__on_dead.emit()
	else: 
		# Not dead
		__on_damage.emit(hp)
