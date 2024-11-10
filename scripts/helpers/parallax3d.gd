extends Sprite3D

var repeat_count: int = 16
var parallax_speed: float = 0.03
var initial_position: Vector3

@onready var camera: Camera3D = Global.level.camera

func _ready():
	initial_position = global_transform.origin

func _process(_delta):
	if camera:
		# Get the camera's position in the world
		var camera_position = camera.global_transform.origin

		# Calculate the offset based on the camera's position and parallax speed
		var assigned_offset = camera_position * parallax_speed

		# Apply the offset to the background layer to simulate parallax
		global_transform.origin = initial_position - assigned_offset

		# Calculate how much the texture should be offset based on the camera's movement
		# The repeat offset is determined by the camera's X position and parallax speed
		var repeat_offset = fmod(camera_position.x * parallax_speed, texture.get_width() * repeat_count)

		# Update the texture's offset for parallax effect (horizontal repeat)
		# The texture will repeat horizontally as the camera moves
		self.offset = Vector2(repeat_offset / texture.get_width(), 0)
