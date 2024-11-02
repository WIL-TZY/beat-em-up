class_name UI extends CanvasLayer

@onready var health_player: ProgressBar = $UIPlayer/HealthPlayer

@onready var ui_enemy: Control = $UIEnemy
@onready var name_enemy: Label = $UIEnemy/NameEnemy
@onready var health_enemy: ProgressBar = $UIEnemy/HealthEnemy
@onready var portrait_enemy: TextureRect = $UIEnemy/PortraitEnemy
@onready var timer_enemy_ui: Timer = $TimerEnemyUI

func _ready() -> void:
	ui_enemy.hide()

func __update_health(hp: float) -> void:
	health_player.value = hp

func __update_enemy(new_name: String, hp: float, hp_max: float, portrait: Texture2D) -> void:
	name_enemy.text = new_name
	health_enemy.value = hp
	health_enemy.max_value = hp_max
	portrait_enemy.texture = portrait
	
	ui_enemy.show()
	timer_enemy_ui.stop()
	timer_enemy_ui.start()
	
	await timer_enemy_ui.timeout
	ui_enemy.hide()
