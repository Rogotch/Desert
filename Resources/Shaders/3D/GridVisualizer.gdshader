shader_type spatial;
render_mode unshaded;

uniform sampler2D noize_img;
uniform float AlfaMult = 1.0;
uniform vec2  XYMult   = vec2(1.0,1.0);
uniform vec3  RGBModifier = vec3(1.0, 1.0, 1.0);
uniform float speed = 1.0;
uniform vec2 Offset = vec2(0.0, 0.0);
uniform float CellSize = 0.1;
uniform float LineWidth = 0.002;
//uniform float len4=0.01;
uniform vec4 color1: hint_color = vec4(1.0,1.0,1.0,0.1); 
uniform vec4 color2: hint_color = vec4(1.0,1.0,1.0,0.25); 

varying vec3 loc_vertex;

void vertex() {
    loc_vertex = VERTEX;
}

void fragment() {
	
	vec2 uv1 = vec2(UV.x + TIME * speed, UV.y * XYMult.y);
	vec2 uv2 = vec2(UV.x - TIME * speed, UV.y * XYMult.y);
	vec2 uv3 = vec2(UV.x * XYMult.x, UV.y + TIME * speed);

	float noize_r = texture(noize_img, uv1).r * RGBModifier.r;
	float noize_g = texture(noize_img, uv1).g * RGBModifier.g;
	float noize_b = texture(noize_img, uv1).b * RGBModifier.b;

	vec3 newColor = vec3(noize_r, noize_g, noize_b);
	
	float newAlfa = noize_r * noize_g * noize_b;
	
	
    if ((mod(Offset.y + loc_vertex.z - LineWidth/2.0, CellSize)<= CellSize - LineWidth) && (mod(Offset.x + loc_vertex.x - LineWidth/2.0, CellSize)<= CellSize - LineWidth))
	{
            ALBEDO = color1.rgb;
            ALPHA = color1.a;
    } 
	else 
	{
            ALBEDO = color2.rgb;
            ALPHA = newAlfa * AlfaMult;
    }
}