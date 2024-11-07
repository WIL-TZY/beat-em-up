class_name HealthComponent extends Node

var host : PhysicsBody3D = null
var hp : float
var hp_max : float
var dead : bool

signal __on_damage(hp)
signal __on_dead
signal __on_recover(hp)

func _ready() -> void:
	host = get_parent()

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

func __recover(gain: float) -> void: 
	var prev_hp = hp
	var new_hp : float = min(hp + gain, hp_max)
	var recovered = new_hp - prev_hp
	hp = new_hp

	# print("HP: %s\nHP Max: %s\nNew HP: %s\nGain: %s\nRecovered: %s" % [prev_hp, hp_max, new_hp, gain, recovered])
	
	# Emit the recovered amount to the HUD
	__on_recover.emit(recovered)
