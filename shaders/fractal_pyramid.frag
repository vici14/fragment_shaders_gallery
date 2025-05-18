#version 300 es

precision mediump float;

// Flutter uniform inputs
layout(location = 0) uniform vec2 resolution;  // viewport dimensions
layout(location = 1) uniform float time;       // animation time
layout(location = 2) uniform vec4 mouse;       // mouse.xy = position, mouse.z = left click, mouse.w = right click

layout(location = 0) out vec4 fragColor;

// Enhanced palette function with mouse control
vec3 palette(float d) {
    // Normalize mouse X position for color control
    float mx = mouse.x / resolution.x;
    
    // Create dynamic color palettes based on mouse position
    vec3 color1 = mix(
        vec3(0.2, 0.7, 0.9),  // Cyan
        vec3(0.9, 0.4, 0.1),  // Orange
        mx
    );
    
    vec3 color2 = mix(
        vec3(1.0, 0.0, 1.0),  // Magenta
        vec3(0.1, 0.8, 0.2),  // Green
        mx
    );
    
    // Mouse Y controls color mixing intensity
    float my = mouse.y / resolution.y;
    float mixFactor = d * (0.5 + my * 1.5);
    
    return mix(color1, color2, mixFactor);
}

// Rotation function (unchanged)
vec2 rotate(vec2 p, float a) {
    float c = cos(a);
    float s = sin(a);
    return p * mat2(c, s, -s, c);
}

// Enhanced distance function with mouse interaction
float map(vec3 p) {
    // Normalize mouse coordinates
    vec2 normalizedMouse = mouse.xy / resolution.xy;
    
    // Mouse X controls iteration intensity
    float mouseXFactor = normalizedMouse.x * 2.0;
    
    // Mouse left button controls folding variation (if clicked)
    float foldVariation = mouse.z > 0.5 ? sin(time) * 0.5 : 0.5;
    
    // Dynamic iteration control based on mouse Y
    int maxIterations = int(mix(5.0, 10.0, normalizedMouse.y));
    
    for(int i = 0; i < 10; ++i) {
        if(i >= maxIterations) break;
        
        float t = time * 0.2;
        
        // Enhanced rotations with mouse influence
        p.xz = rotate(p.xz, t + mouseXFactor * 0.5);
        p.xy = rotate(p.xy, t * 1.89 + mouseXFactor * 0.3);
        
        // Folding operations
        p.xz = abs(p.xz);
        p.xz -= foldVariation + normalizedMouse.y * 0.5;
        
        // Mouse-controlled deformation
        if(mouse.z > 0.5) {
            // Special effect when clicking
            p.y += 0.1 * sin(8.0 * p.x + time * 2.0);
        }
    }
    
    return dot(sign(p), p) / 5.0;
}

// Enhanced ray marching with adjustable quality
vec4 rm(vec3 ro, vec3 rd) {
    // Normalize mouse Y for quality control
    float my = mouse.y / resolution.y;
    
    // Higher quality when mouse is higher in the viewport
    float maxSteps = mix(32.0, 96.0, my);
    
    // Mouse right button controls glow intensity
    float glowIntensity = mouse.w > 0.5 ? 200.0 : 400.0;
    
    float t = 0.0;
    vec3 col = vec3(0.0);
    float d;
    
    for(float i = 0.0; i < 96.0; i++) {
        if(i >= maxSteps) break;
        
        vec3 p = ro + rd * t;
        d = map(p) * 0.5;
        
        if(d < 0.02) {
            break;
        }
        
        if(d > 100.0) {
            break;
        }
        
        // Enhanced glow effect
        col += palette(length(p) * 0.1) / (glowIntensity * (d));
        t += d;
    }
    
    return vec4(col, 1.0 / (d * 100.0));
}

void main() {
    vec2 fragCoord = gl_FragCoord.xy;
    vec2 uv = (fragCoord - (resolution.xy / 2.0)) / resolution.x;
    
    // Normalize mouse coordinates for camera control
    vec2 normalizedMouse = (mouse.xy / resolution.xy) * 2.0 - 1.0;
    
    // Base camera position
    vec3 ro = vec3(0.0, 0.0, -50.0);
    
    // Camera control with mouse
    // When right mouse button is pressed, enable direct camera control
    if(mouse.w > 0.5) {
        // Direct mouse control of camera angle
        ro.xz = rotate(ro.xz, normalizedMouse.x * 3.14159);
        ro.yz = rotate(ro.yz, normalizedMouse.y * 3.14159);
    } else {
        // Regular time-based animation with subtle mouse influence
        ro.xz = rotate(ro.xz, time + normalizedMouse.x * 0.5);
        ro.yz = rotate(ro.yz, sin(time * 0.5) * 0.5 + normalizedMouse.y * 0.3);
    }
    
    // Regular camera setup
    vec3 cf = normalize(-ro);
    vec3 cs = normalize(cross(cf, vec3(0.0, 1.0, 0.0)));
    vec3 cu = normalize(cross(cf, cs));
    
    // Mouse position also affects field of view when left clicked
    float fov = 3.0;
    if(mouse.z > 0.5) {
        fov = mix(2.0, 4.0, normalizedMouse.y); // Zoom effect
    }
    
    vec3 uuv = ro + cf * fov + uv.x * cs + uv.y * cu;
    vec3 rd = normalize(uuv - ro);
    
    fragColor = rm(ro, rd);
}