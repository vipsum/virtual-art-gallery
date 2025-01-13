// Run this on shadertoy and do a screenshot to generate the floor texture

// https://www.shadertoy.com/view/4sfGzS
float hash(vec3 p) {
    p  = fract(p * 0.3183099 + .1);
    p *= 17.0;
    return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

float noise(in vec3 x) {
    vec3 i = floor(x);
    vec3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(mix(hash(i + vec3(0, 0, 0)), hash(i + vec3(1, 0, 0)), f.x),
                   mix(hash(i + vec3(0, 1, 0)), hash(i + vec3(1, 1, 0)), f.x), f.y),
                mix(mix(hash(i + vec3(0, 0, 1)), hash(i + vec3(1, 0, 1)), f.x),
                   mix(hash(i + vec3(0, 1, 1)), hash(i + vec3(1, 1, 1)), f.x), f.y), f.z);
}

#define fbm2(g) fbm3(vec3(g, 0.0))
float fbm3(vec3 p) {
    float f = 0.0, x;
    for (int i = 1; i <= 9; ++i) {
        x = exp2(float(i));
        f += (noise(p * x) - 0.5) / x;
    }
    return f;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / 1024.0;

    // Sample the wood texture directly
    vec3 woodColor = texture2D(floorTexture, uv).rgb; // Use the wood texture

    // Output to screen with full opacity
    fragColor = vec4(woodColor, 1.0); // Fully opaque
}