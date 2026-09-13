#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

const vec3 c1 = vec3(0.608, 0.737, 0.059);
const vec3 c2 = vec3(0.545, 0.675, 0.059);
const vec3 c3 = vec3(0.188, 0.384, 0.188);
const vec3 c4 = vec3(0.059, 0.220, 0.059);

void main() {
    vec2 resolution = vec2(320.0, 180.0);
    vec2 pixelatedUV = floor(texCoord * resolution) / resolution;

    vec4 texColorCenter = texture(InSampler, pixelatedUV);
    vec4 texColorGhost1 = texture(InSampler, pixelatedUV - vec2(2.0 / resolution.x, 0.0));
    vec4 texColorGhost2 = texture(InSampler, pixelatedUV - vec2(4.0 / resolution.x, 0.0));
    
    vec4 texColor = texColorCenter * 0.7 + texColorGhost1 * 0.2 + texColorGhost2 * 0.1;

    float luminance = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
    
    luminance = clamp((luminance - 0.5) * 1.5 + 0.5, 0.0, 1.0);

    vec3 finalColor;
    if (luminance > 0.75) {
        finalColor = c1;
    } else if (luminance > 0.5) {
        finalColor = c2;
    } else if (luminance > 0.25) {
        finalColor = c3;
    } else {
        finalColor = c4;
    }

    vec2 pixelPos = fract(texCoord * resolution);
    
    float gridX = smoothstep(0.0, 0.15, pixelPos.x) * smoothstep(1.0, 0.85, pixelPos.x);
    float gridY = smoothstep(0.0, 0.15, pixelPos.y) * smoothstep(1.0, 0.85, pixelPos.y);
    float grid = gridX * gridY;

    finalColor *= mix(0.6, 1.0, grid);

    float flicker = fract(sin(dot(texCoord.xy, vec2(12.9898, 78.233)) + GameTime * 100.0) * 43758.5453) * 0.03;
    finalColor -= flicker;

    fragColor = vec4(finalColor, texColorCenter.a);
}
