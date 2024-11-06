extends Sprite2D

const SCALE : int = 2

func take_screenshot() -> void:
	var viewport_size = get_viewport().get_size() * SCALE
	var viewport_width = viewport_size.x 
	var viewport_height = viewport_size.y 
	
	# Capture the current viewport as a texture
	var img = get_viewport().get_texture().get_image()
	img.resize(viewport_width, viewport_height)
	
	# Flip the image vertically
	img.flip_y() 
	
	var screenshot = ImageTexture.create_from_image(img) # Static call
	texture = screenshot  
