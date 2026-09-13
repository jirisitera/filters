#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

float random(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = texCoord;
    float time = GameTime * 1200.0;
    // offset bands
    float band = floor(uv.y * 150.0); 
    float offset = 0.0;
    if (random(vec2(time * 0.01, band)) > 0.98) {
        offset = (random(vec2(time, band)) - 0.5) * 0.015;
    }
    // chromatic abberation
    float dist = length(uv - 0.5);
    float caStrength = dist * 0.008;
    if (abs(offset) > 0.005) {
        caStrength += 0.015;
    }
    if (random(vec2(time * 0.02, 0.0)) > 0.98) {
        caStrength += 0.015;
    }
    // distortion
    vec2 distortedUV = uv + vec2(offset, 0.0);
    vec4 colR = texture(InSampler, distortedUV + vec2(caStrength, 0.0));
    vec4 colG = texture(InSampler, distortedUV);
    vec4 colB = texture(InSampler, distortedUV - vec2(caStrength, 0.0));
    // noise
    float noise = 0.0;
    if (abs(offset) > 0.0) {
        noise = (random(uv + vec2(time)) - 0.5) * 0.04;
    }
    fragColor = vec4(colR.r + noise, colG.g + noise, colB.b + noise, colG.a);
}
