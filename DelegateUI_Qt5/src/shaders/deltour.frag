#version 450

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

uniform mat4 qt_Matrix;
uniform float qt_Opacity;
uniform float xMin;
uniform float xMax;
uniform float yMin;
uniform float yMax;

layout(binding = 1) uniform sampler2D source;

void main() {
    vec4 tex = texture(source, qt_TexCoord0);
    if (qt_TexCoord0.x > xMin && qt_TexCoord0.x < xMax
        && qt_TexCoord0.y > yMin && qt_TexCoord0.y < yMax)
        fragColor = vec4(0);
    else
        fragColor = tex * qt_Opacity;
}
