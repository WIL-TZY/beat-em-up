class_name UI extends CanvasLayer

# Go
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Player
@onready var hud_player: Control = $UIGameplay/HUDPlayer
@onready var name_player: Label = $UIGameplay/HUDPlayer/NamePlayer
@onready var health_player: ProgressBar = $UIGameplay/HUDPlayer/HealthPlayer
@onready var portrait_player: TextureRect = $UIGameplay/HUDPlayer/PortraitPlayer

# Enemy
@onready var hud_enemy: Control = $UIGameplay/HUDEnemy
@onready var name_enemy: Label = $UIGameplay/HUDEnemy/NameEnemy
@onready var health_enemy: ProgressBar = $UIGameplay/HUDEnemy/HealthEnemy
@onready var portrait_enemy: TextureRect = $UIGameplay/HUDEnemy/PortraitEnemy
@onready var timer_enemy_ui: Timer = $TimerEnemyUI

func _ready() -> void:
	hud_enemy.hide()

func __hud_update_health(hp: float) -> void:
	health_player.value = hp

func __hud_update_player(properties: CharacterData) -> void:
	name_player.text = properties.name
	health_player.value = properties.hp
	health_player.max_value = properties.hp
	portrait_player.texture = properties.portrait

func __hud_update_enemy(new_name: String, hp: float, hp_max: float, portrait: Texture2D) -> void:
	name_enemy.text = new_name
	health_enemy.value = hp
	health_enemy.max_value = hp_max
	portrait_enemy.texture = portrait
	
	hud_enemy.show()
	timer_enemy_ui.stop()
	timer_enemy_ui.start()
	
	await timer_enemy_ui.timeout
	hud_enemy.hide()

func __show_go() -> void:
	animation_player.play("go")
	await get_tree().create_timer(2).timeout
	animation_player.stop()
	$Go.hide()

func __level_cleared() -> void:
	# Pause level music
	var level_music = get_parent().get_node("AudioStreamPlayer")
	level_music.stop()

	# Show Level Cleared HUD
	var hud_level_cleared = $UIGameplay/HUDLevelCleared
	hud_level_cleared.show()
	var level_clear_music = get_node("LevelClearedJingle")
	level_clear_music.play()
	
	# Timer
	await get_tree().create_timer(5).timeout
	
	# Change back to menu
	get_tree().change_scene_to_file("res://scenes/ui/ui_player_selector.tscn")
