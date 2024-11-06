extends CanvasLayer

signal transitioned_in()
signal transitioned_out()

enum TransitionType { FADE, PIXELATE }

var current_scene : Node: set=set_current_scene
var in_transition: bool = false
var transition_type: TransitionType = TransitionType.FADE

var out_animation: String = "fade_out"
var in_animation: String = "fade_in"

# Temporary variables
var previous_transition_type: TransitionType
var previous_out_animation: String

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var margin_container: MarginContainer = $Control/MarginContainer
@onready var screenshot_texture_rect: TextureRect = $Control/Screenshot

func _ready() -> void:
	current_scene = get_tree().current_scene
	update_transition_animations()

# Runs every new scene
func set_current_scene(value: Node) -> void:
	if current_scene == null:
		current_scene = value
		return
	
	current_scene = value
	var root: Window = get_tree().get_root()
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(value)
	
	update_transition_animations()

# Update animations based on the current scene's properties or transition type
func update_transition_animations(type : TransitionType = current_scene.transition_type) -> void:
	transition_type = type
	
	if transition_type == TransitionType.FADE:
		out_animation = "fade_out"
		in_animation = "fade_in"
	elif transition_type == TransitionType.PIXELATE:
		out_animation = "pixelate_out"
		in_animation = "pixelate_in"

func transition_in() -> void:
	if transition_type == TransitionType.PIXELATE:
		transition_pixelate_in()
	elif transition_type == TransitionType.FADE:
		transition_fade_in()

func transition_out() -> void:
	if previous_transition_type == TransitionType.PIXELATE:
		transition_pixelate_out()
	elif previous_transition_type == TransitionType.FADE:
		transition_fade_out()

# Transition to a new scene
func transition_to(scene: String, type: TransitionType = transition_type) -> void:
	if in_transition: return # Return early if already in transition
	in_transition = true

	update_transition_animations(type)
	previous_transition_type = transition_type
	previous_out_animation = out_animation
	
	transition_in()
	await transitioned_in

	## MANUALLY LOADING SCENES
	# Load and instantiate the new scene
	var new_scene = load(scene).instantiate()

	# Free the old scene
	if current_scene != null: current_scene.queue_free()  
	current_scene = new_scene

	# Check if the new scene is already in the tree
	var root = get_tree().get_root()
	if not new_scene.is_inside_tree():
		# Add new scene to the tree
		root.add_child(new_scene)

	new_scene.load_scene()

	if new_scene.emits_loaded_signal:
		await new_scene.loaded

	transition_out()
	await transitioned_out

	# Check that new_scene is still valid before calling activate
	if new_scene != null and new_scene.is_inside_tree():
		new_scene.activate()

	in_transition = false

# Animated Transition functions
# Fade in transition logic
func transition_fade_in() -> void:
	animation_player.play(in_animation)

# Fade out transition logic
func transition_fade_out() -> void:
	show_loading_label()
	animation_player.play(previous_out_animation)

# Pixelate in transition logic
func transition_pixelate_in() -> void:
	screenshot_texture_rect.take_screenshot()
	screenshot_texture_rect.visible = true
	animation_player.play(in_animation)

# Pixelate out transition logic
func transition_pixelate_out() -> void:
	screenshot_texture_rect.take_screenshot()
	screenshot_texture_rect.visible = true
	animation_player.play(previous_out_animation)
	
	# Helper function to display the loading label
func show_loading_label() -> void:
	# Display loading label only during fade transitions
	create_tween().tween_property(margin_container, "scale", Vector2.ZERO, 0.3)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == in_animation:
		# Pulse the loading label if using fade transitions
		if transition_type == TransitionType.FADE:
			animation_player.play("pulse_text")
		transitioned_in.emit()
	elif anim_name == previous_out_animation:
		transitioned_out.emit()
		# Hide screenshot after pixelate transition
		screenshot_texture_rect.visible = false
