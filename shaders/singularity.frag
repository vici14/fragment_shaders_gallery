#version 300 es

precision highp float;

// Uniforms passed from Flutter
uniform vec2 resolution;   // Canvas size
uniform float time;        // Animation time
uniform vec2 touch;        // Touch position

// Output
out vec4 fragColor;

void main() {
    //Iterator and attenuation (distance-squared)
    float i = 0.2, a;
    //Resolution for scaling and centering
    vec2 r = resolution,
         //Centered ratio-corrected coordinates
         p = (gl_FragCoord.xy + gl_FragCoord.xy - r) / r.y / 0.7,
         //Diagonal vector for skewing
         d = vec2(-1.0, 1.0),
         //Blackhole center
         b = p - i*d,
         //Rotate and apply perspective
         c = p * mat2(1.0, 1.0, d.x/(.1 + i/dot(b,b)), d.y/(.1 + i/dot(b,b))),
         //Waves cumulative total for coloring
         w = vec2(0.0);
    
    //Rotate into spiraling coordinates
    a = dot(c,c);
    float angle = 0.5*log(a) + time*i;
    mat2 rotMat = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
    vec2 v = c * rotMat / i;
    
    //Loop through waves
    for(int j = 0; j < 9; j++) {
        i += 1.0;
        //Distort coordinates
        v += 0.7 * sin(vec2(v.y, v.x)*i + time) / i + 0.5;
        w += 1.0 + sin(v);
    }
    
    //Acretion disk radius
    i = length(sin(v/0.3)*0.4 + c*(3.0+d));
    
    //Red/blue gradient
    vec4 colorBase = vec4(0.6, -0.4, -1.0, 0.0);
    vec4 waveColor = vec4(w.x, w.y, w.y, w.x);
    float diskBrightness = 2.0 + i*i/4.0 - i;
    float centerDarkness = 0.5 + 1.0 / a;
    float rimHighlight = 0.03 + abs(length(p)-0.7);
    
    vec4 O = vec4(1.0) - exp(-exp(c.x * colorBase) / waveColor / diskBrightness / centerDarkness / rimHighlight);
    
    // Apply touch interaction - shift the blackhole center
    vec2 touchPos = touch / resolution;
    if (touch.x > 0.0 && touch.y > 0.0) {
        touchPos = touchPos * 2.0 - 1.0;
        O *= 1.0 - 0.2 * length(p - touchPos * 0.5);
    }
    
    fragColor = O;
} 