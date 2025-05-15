#version 300 es

precision mediump float;

// Flutter uniform inputs
layout(location = 0) uniform vec2 resolution;
layout(location = 1) uniform float time;
layout(location = 2) uniform vec2 mouse;

layout(location = 0) out vec4 fragColor;

void main() {
    vec2 uv = gl_FragCoord.xy/resolution.xy;
    
    // Create animated wave pattern
    float frequency = 10.0;
    float amplitude = 0.1;
    float wave = sin(uv.x * frequency + time) * amplitude;
    
    // Distort the UV coordinates
    uv.y += wave;
    
    // Create gradient colors
    vec3 color1 = vec3(0.0, 0.5, 0.9);
    vec3 color2 = vec3(0.9, 0.1, 0.8);
    vec3 finalColor = mix(color1, color2, uv.y + 0.5 * sin(time * 0.5));
    
    // Add some movement
    finalColor += 0.05 * sin(time + uv.x * 5.0);
    
    fragColor = vec4(finalColor, 1.0);
} 