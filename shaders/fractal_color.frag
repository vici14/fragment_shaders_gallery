#version 300 es

precision highp float;

// Flutter uniform inputs (replacing ShaderToy inputs)
layout(location = 0) uniform vec2 resolution;  // replaces iResolution.xy
layout(location = 1) uniform float time;       // replaces iTime
layout(location = 2) uniform vec2 mouse;       // replaces iMouse (optional)

layout(location = 0) out vec4 fragColor;

/* This animation is from a tutorial about creative coding
   which introduces programmers to GLSL and the world of shaders.
   Original by kishimisu: https://youtu.be/f4s1h2YETNY
*/

//https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a + b*cos(6.28318*(c*t+d));
}

void main() {
    vec2 fragCoord = gl_FragCoord.xy;
    vec2 uv = (fragCoord * 2.0 - resolution.xy) / resolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);
    
    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i*0.4 + time*0.4);

        d = sin(d*8.0 + time)/8.0;
        d = abs(d);

        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    }
        
    fragColor = vec4(finalColor, 1.0);
} 