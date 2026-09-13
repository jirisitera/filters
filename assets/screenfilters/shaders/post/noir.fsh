#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    vec4 texColor = texture(InSampler, texCoord);

    float luminance = dot(texColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    float grayscale = smoothstep(0.15, 0.85, luminance);

    float noise = (random(texCoord * 1000.0 + GameTime * 1200.0) - 0.5) * 0.25;
    float vignette = smoothstep(0.85, 0.15, length(texCoord - 0.5));

    fragColor = vec4(vec3((grayscale + noise) * vignette), texColor.a);
}
