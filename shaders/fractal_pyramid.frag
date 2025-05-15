#version 300 es

precision mediump float;

// Flutter uniform inputs (replacing ShaderToy inputs)
layout(location = 0) uniform vec2 resolution;  // replaces iResolution.xy
layout(location = 1) uniform float time;       // replaces iTime
layout(location = 2) uniform vec2 mouse;       // replaces iMouse (optional)

layout(location = 0) out vec4 fragColor;

// Helper functions for fractal pyramid shader
vec3 palette(float d) {
    return mix(vec3(0.2, 0.7, 0.9), vec3(1.0, 0.0, 1.0), d);
}

vec2 rotate(vec2 p, float a) {
    float c = cos(a);
    float s = sin(a);
    return p * mat2(c, s, -s, c);
}

float map(vec3 p) {
    for(int i = 0; i < 8; ++i) {
        float t = time * 0.2;
        p.xz = rotate(p.xz, t);
        p.xy = rotate(p.xy, t * 1.89);
        p.xz = abs(p.xz);
        p.xz -= 0.5;
    }
    return dot(sign(p), p) / 5.0;
}

vec4 rm(vec3 ro, vec3 rd) {
    float t = 0.0;
    vec3 col = vec3(0.0);
    float d;
    
    for(float i = 0.0; i < 64.0; i++) {
        vec3 p = ro + rd * t;
        d = map(p) * 0.5;
        
        if(d < 0.02) {
            break;
        }
        
        if(d > 100.0) {
            break;
        }
        
        col += palette(length(p) * 0.1) / (400.0 * (d));
        t += d;
    }
    
    return vec4(col, 1.0 / (d * 100.0));
}

// Main function (replacing ShaderToy's mainImage)
void main() {
    vec2 fragCoord = gl_FragCoord.xy;
    vec2 uv = (fragCoord - (resolution.xy / 2.0)) / resolution.x;
    
    vec3 ro = vec3(0.0, 0.0, -50.0);
    ro.xz = rotate(ro.xz, time);
    
    vec3 cf = normalize(-ro);
    vec3 cs = normalize(cross(cf, vec3(0.0, 1.0, 0.0)));
    vec3 cu = normalize(cross(cf, cs));
    
    vec3 uuv = ro + cf * 3.0 + uv.x * cs + uv.y * cu;
    vec3 rd = normalize(uuv - ro);
    
    fragColor = rm(ro, rd);
}