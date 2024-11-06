extends CanvasLayer

signal transitioned_in()
signal transitioned_out()

var current_scene : Node: set=set_current_scene

@export var fade_out_animation: String = "out"
@export var fade_in_animation: String = "in"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var margin_container: MarginContainer = $MarginContainer
# @onready var shader_material: ShaderMaterial = material

func _ready() -> void:
	current_scene = get_tree().current_scene

func set_current_scene(value: Node) -> void:
	if current_scene == null:
		current_scene = value
		return
	
	current_scene = value
	var root: Window = get_tree().get_root()
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(value)

func transition_in() -> void:
	animation_player.play(fade_in_animation)

func transition_out() -> void:
	create_tween().tween_property(margin_container, "scale", Vector2.ZERO, 0.3)
	animation_player.play(fade_out_animation)

func transition_to(scene: String) -> void:
	transition_in()
	await transitioned_in
	
	var new_scene = load(scene).instantiate()
	
	current_scene = new_scene
	
	new_scene.load_scene()
	await new_scene.loaded
	
	transition_out()
	await transitioned_out
	
	# Run activate function (sometimes has unexpected behavior)
	new_scene.activate()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == fade_in_animation:
		# Loading Label
		animation_player.play("pulse_text")
		transitioned_in.emit()
	elif anim_name == fade_out_animation:
		transitioned_out.emit()
