extends StaticBody3D

var hp := 1
@export var drop : PackedScene = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_collision: CollisionShape3D = $HitboxComponent/HitboxCollision

func _ready() -> void:
	health_component.hp = hp

	# Connect the signal manually
	# health_component.__on_damage.connect(func(_hp: float): pass)
	health_component.__on_dead.connect(func(): take_damage())

### DAMAGE
func take_damage() -> void:
	health_component.dead = true
	_drop_item()
	print("Barrel damaged")
	animation_player.play("broken")

func _drop_item() -> void:
	if drop:
		var item = drop.instantiate()
		
		# Item spaws at the same position of the destructible
		item.transform.origin = transform.origin
		get_parent().add_child(item)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
