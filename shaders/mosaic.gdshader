shader_type canvas_item;

uniform float pixelFactor : hint_range(0, 1) = 0.5; // Pixel size

void fragment() {
	// Create effect
    vec2 pixelNumber = vec2(textureSize(TEXTURE, 0)) * pixelFactor;
    vec2 pixelatedUV = round(UV * pixelNumber) / pixelNumber;
    COLOR = texture(TEXTURE, pixelatedUV);
}
