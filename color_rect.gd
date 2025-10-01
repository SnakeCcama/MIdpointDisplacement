extends ColorRect


var pointsArray = [Vector2(0.0,0.1), Vector2(1.0,0.2)]
var may = 0

func points(pt1: Vector2, pt2:Vector2, its: int, count: int, disp:float, roughn:float):
	
	
	if (count >= its):	
		return;
	
	var halfw = pt1 + (pt2 - pt1)/2.0
	halfw.y += disp
	pointsArray.append(halfw)
	disp *= pow(2, -roughn)
	
	
	points(pt1, halfw, its, count + 1, disp, roughn)
	points(halfw, pt2, its, count + 1, disp, roughn)
		
	
func make_points_texture(verts: Array):
	var img = Image.create(verts.size(), 1, false, Image.FORMAT_RGBAF)
	for i in range(verts.size()):
		var p = verts[i]
		img.set_pixel(i, 0, Color(p.x, p.y, 0.0, 1.0))
	var tex = ImageTexture.create_from_image(img);
	material.set_shader_parameter("num_points", verts.size())
	material.set_shader_parameter("points_tex", tex)
	
func _ready():
	var viewport_size = get_viewport_rect().size
	material.set_shader_parameter("u_resolution", viewport_size)
	points(pointsArray[0], pointsArray[1], 5, 0, 0.2, 0.9)
	pointsArray.sort()
	make_points_texture(pointsArray)
	

func _process(delta: float):
	
	pass


func _on_h_slider_value_changed(value: float) -> void:
	pass
