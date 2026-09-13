#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

layout(location = 0) out vec2 texCoord;

float random(float x) {
    return fract(sin(x * 12.9898) * 43758.5453);
}

void main() {
    texCoord = vec2((gl_VertexIndex << 1) & 2, gl_VertexIndex & 2);
    vec4 pos = vec4(texCoord * vec2(2.0) + vec2(-1.0), 0.0, 1.0);
    float time = GameTime * 1200.0;
    float jitter = 0.0;
    // slight shaking
    float trigger = random(floor(time * 0.02));
    if (trigger > 0.9) {
        jitter = sin(fract(time * 0.02) * 3.14159 * 2.0) * 0.003;
    }
    pos.x += jitter;
    gl_Position = pos;
}
