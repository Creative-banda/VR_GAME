shader_type spatial;

uniform float cutoff_y = 0.0; // This will be the height of your Plane node
uniform vec4 filament_color : source_color = vec4(0.1, 0.6, 1.0, 1.0);

void fragment() {
    // 1. Get the world position of this specific pixel
    float world_y = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;

    // 2. If the pixel's world height is higher than our plane, hide it
    if (world_y > cutoff_y) {
        discard;
    }

    ALBEDO = filament_color.rgb;
}