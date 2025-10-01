shader_type canvas_item;

uniform vec2 u_resolution;
uniform sampler2D points_tex;
uniform int num_points;


vec2 get_point0(int idx)
{
	
	float u = (float(idx) + 0.5) / float(textureSize(points_tex, 0).x);
	vec4 texel = texture(points_tex, vec2(u, 0.5));
	return vec2(texel.r, texel.g);
}

float line(vec2 pt1, vec2 pt2, vec2 st)
{

	st.y = 1.0 - st.y;

	float m;
	m = (pt2.y - pt1.y)/(pt2.x - pt1.x);

	float b;
	b = (pt1.y - m*pt1.x);

	if(st.x >= pt1.x && st.x<= pt2.x)
	{
		return step(st.y, (m * st.x + b));
	}else
	{
		return 0.0;
	}

}


vec2 get_point_normalized(float normalized_index) {
    int index = int(normalized_index * float(num_points - 1));
    return get_point0(index);
}

vec2 get_point1(int indx)
{
	vec2 coord0;
	vec2 coord1;
	
	vec4 pixel0 = texelFetch(points_tex, ivec2(indx, 0), 0);
	coord0 = vec2(pixel0.r, pixel0.g);
	/*
	for (int i = 0; i<size.x; i++)
	{
		vec4 pixel0 = texelFetch(points_tex, ivec2(i, 0), 0);
		vec4 pixel1 = texelFetch(points_tex, ivec2(i + 1, 0), 0);
		coord0 = vec2(pixel0.r, pixel0.g);
		coord1 = vec2(pixel1.r, pixel1.g);
	}*/
	
	return coord0;
	
}


void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {

	ivec2 size = textureSize(points_tex, 0);
	
	vec2 pt = get_point1(2);
	vec2 pt1 = get_point1(5); 
	float pct;

	vec2 st = FRAGCOORD.xy/u_resolution;
	vec3 color = vec3(0.529, 0.808, 0.980);
	
	for (int i = 0; i<size.x - 1; i++)
	{
		pt = get_point0(i);
		pt1 = get_point0(i + 1);
		
		pct = line(pt, pt1, SCREEN_UV);
		color = (1.0 - pct) * color + pct * vec3(0.804, 0.522, 0.247);
		
	}

	
	

	COLOR = vec4(color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
