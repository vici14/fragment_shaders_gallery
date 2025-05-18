#version 300 es

precision mediump float;

// Flutter uniform inputs (replacing ShaderToy inputs)
layout(location = 0) uniform vec2 resolution;  // replaces iResolution.xy
layout(location = 1) uniform float time;       // replaces iTime
layout(location = 2) uniform vec2 mouse;       // replaces iMouse (optional)

layout(location = 0) out vec4 fragColor;

// Custom tanh implementation using exponentials
vec4 custom_tanh(vec4 x) {
    vec4 exp2x = exp(2.0 * x);
    return (exp2x - 1.0) / (exp2x + 1.0);
}

/*
    "Waveform" by @XorDev
    Adapted for Flutter Fragment Shaders Gallery
*/
void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
    
    // Simple implementation first to ensure it compiles
    float maxDist = 90.0;
    float z = 0.0;
    
    for(float i = 0.0; i < 30.0; i += 1.0) {
        // Create ray
        vec3 p = vec3(uv * 2.0 - 1.0, 0.0);
        p.z = 1.0 - p.x * p.x - p.y * p.y;
        p = normalize(p);
        
        // Move along ray
        p = p * z;
        
        // Wave effect
        float wave = 0.0;
        for(float d = 1.0; d < 8.0; d += 1.0) {
            wave += sin(p.x * d + time * d * 0.5) / d;
            wave += sin(p.z * d + time * d * 0.5) / d;
        }
        
        // Add color
        float brightness = 1.0 / (1.0 + z * z * 0.1);
        vec4 waveColor = vec4(
            0.5 + 0.5 * sin(z * 0.1 + time),
            0.5 + 0.5 * sin(z * 0.1 + time + 2.0),
            0.5 + 0.5 * sin(z * 0.1 + time + 4.0),
            1.0
        );
        
        color += waveColor * wave * brightness / 30.0;
        
        // Advance ray
        z += 1.0 + wave * 0.2;
        
        if(z > maxDist) break;
    }
    
    // Use our custom tanh for tone mapping
    fragColor = custom_tanh(color);
} 