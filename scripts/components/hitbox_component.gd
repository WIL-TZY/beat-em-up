class_name HitboxComponent extends Area3D

@export var health_component: HealthComponent

func __take_damage(damage: float) -> void: 
	if health_component:
		health_component.__take_damage(damage)
