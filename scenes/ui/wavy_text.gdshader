shader_type canvas_item;

void vertex() {
	VERTEX.y += 3.0*sin(TIME+500.0*VERTEX.x);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
