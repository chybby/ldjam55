shader_type spatial;

void fragment() {
    ALBEDO = COLOR.rgb;
    EMISSION = COLOR.rgb * 5.0;
}
