#version 300 es

precision mediump float;

// Flutter uniform inputs
layout(location = 0) uniform vec2 resolution;
layout(location = 1) uniform float time;
layout(location = 2) uniform vec2 mouse;

layout(location = 0) out vec4 fragColor;

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
    
    // Calculate distance from center
    float dist = length(uv);
    
    // Create pulsing circle
    float pulse = sin(time * 2.0) * 0.1 + 0.3;
    float circle = smoothstep(pulse, pulse - 0.05, dist);
    
    // Create color based on distance and time
    vec3 color = vec3(0.0);
    color.r = circle * (0.5 + 0.5 * sin(time + uv.x * 5.0));
    color.g = circle * (0.5 + 0.5 * cos(time * 0.7 + dist * 10.0));
    color.b = circle * (0.5 + 0.5 * sin(time * 0.5 - uv.y * 5.0));
    
    // Add background color
    vec3 bgColor = vec3(0.05, 0.05, 0.1) + 0.03 * vec3(sin(time), cos(time), sin(time * 0.5));
    color = mix(bgColor, color, circle);
    
    fragColor = vec4(color, 1.0);
} 