#define PI 3.1415926535897932384626433832795

varying vec2 vUv;

//  Classic Perlin 2D Noise 
//  by Stefan Gustavson
//
vec4 permute(vec4 x)
{
    return mod(((x*34.0)+1.0)*x, 289.0);
}

vec2 fade(vec2 t)
{
    return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float cnoise(vec2 P)
{
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    vec4 i = permute(permute(ix) + iy);
    vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    vec2 g00 = vec2(gx.x,gy.x);
    vec2 g10 = vec2(gx.y,gy.y);
    vec2 g01 = vec2(gx.z,gy.z);
    vec2 g11 = vec2(gx.w,gy.w);
    vec4 norm = 1.79284291400159 - 0.85373472095314 * vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
    return vec2(
      cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
      cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

void main()
{
    gl_FragColor = vec4(vUv, 1.0, 1.0); // pattern 1

    gl_FragColor = vec4(0.0, vUv, 1.0); // pattern 2

    float strength = vUv.x;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 3

    strength = vUv.y;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 4-5

    strength = vUv.y * 10.0;
    gl_FragColor = vec4(vec3(strength), 1.0); // patternt 6

    strength = mod(vUv.y * 10.0, 1.0);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 7

    strength = step(0.5, strength);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 8

    strength = mod(vUv.y * 10.0, 1.0);
    strength = step(0.8, strength);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 9-10

    strength = step(0.8, mod(vUv.x * 10.0, 1.0));
    strength += step(0.8, mod(vUv.y * 10.0, 1.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 11

    strength = step(0.8, mod(vUv.x * 10.0, 1.0));
    strength *= step(0.8, mod(vUv.y * 10.0, 1.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 12

    strength = step(0.4, mod(vUv.x * 10.0, 1.0));
    strength *= step(0.8, mod(vUv.y * 10.0, 1.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 13

    strength = step(0.4, mod(vUv.x * 10.0, 1.0));
    strength *= step(0.4, mod(vUv.y * 10.0, 1.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 14

    float barX = step(0.4, mod(vUv.x * 10.0, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));
    float barY = step(0.8, mod(vUv.x * 10.0, 1.0)) * step(0.4, mod(vUv.y * 10.0, 1.0));
    strength = barX + barY;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 15

    barX = step(0.4, mod(vUv.x * 10.0 - 0.2, 1.0)) * step(0.8, mod(vUv.y * 10.0, 1.0));
    barY = step(0.8, mod(vUv.x * 10.0, 1.0)) * step(0.4, mod(vUv.y * 10.0 - 0.2, 1.0));
    strength = barX + barY;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 16

    gl_FragColor = vec4(vec3(abs(vUv.x - 0.5)), 1.0); // pattern 17

    strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));
    gl_FragColor = vec4(vec3(strength), 1.0);

    strength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 18

    strength = step(0.2, strength);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 19-20

    strength = floor(vUv.x * 10.0) / 10.0;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 21

    strength *= floor(vUv.y * 10.0) / 10.0;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 22

    strength = random(vUv);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 23

    vec2 gridUv = vec2(floor(vUv.x * 10.0) / 10.0, floor(vUv.y * 10.0) / 10.0);
    strength = random(gridUv);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 24

    gridUv = vec2(floor(vUv.x * 10.0) / 10.0, floor((vUv.y + vUv.x * 0.5) * 10.0) / 10.0);
    strength = random(gridUv);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 25

    strength = length(vUv);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 26

    strength = distance(vUv, vec2(0.5));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 27

    strength = 1.0 - distance(vUv, vec2(0.5));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 28

    strength = 0.015 / (distance(vUv, vec2(0.5)));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 29

    strength = 0.15 / (distance(vec2(vUv.x, (vUv.y - 0.5) * 5.0 + 0.5), vec2(0.5)));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 30

    strength = 0.15 / (distance(vec2(vUv.x, (vUv.y - 0.5) * 5.0 + 0.5), vec2(0.5)));
    strength *= 0.15 / (distance(vec2(vUv.y, (vUv.x - 0.5) * 5.0 + 0.5), vec2(0.5)));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 31

    vec2 rotatedUv = rotate(vUv, PI * 0.25, vec2(0.5));
    strength = 0.15 / (distance(vec2(rotatedUv.x, (rotatedUv.y - 0.5) * 5.0 + 0.5), vec2(0.5)));
    strength *= 0.15 / (distance(vec2(rotatedUv.y, (rotatedUv.x - 0.5) * 5.0 + 0.5), vec2(0.5)));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 32

    strength = step(0.5, distance(vUv, vec2(0.5)) + 0.25);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 33

    strength = abs(distance(vUv, vec2(0.5)) - 0.25);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 34

    strength = step(0.02, abs(distance(vUv, vec2(0.5)) - 0.25));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 35

    strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 36

    vec2 wavedUv = vec2(
        vUv.x,
        vUv.y + sin(vUv.x * 30.0) * 0.1
    );
    strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - 0.25));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 37

    wavedUv = vec2(
        vUv.x + sin(vUv.y * 30.0) * 0.1,
        vUv.y + sin(vUv.x * 30.0) * 0.1
    );
    strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - 0.25));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 38

    wavedUv = vec2(
        vUv.x + sin(vUv.y * 100.0) * 0.1,
        vUv.y + sin(vUv.x * 100.0) * 0.1
    );
    strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - 0.25));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 39

    float angle = atan(vUv.x, vUv.y);
    strength = angle;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 40

    angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    strength = angle;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 41

    angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
    strength = angle;
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 42

    angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
    strength = mod(angle * 20.0, 1.0);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 43

    angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
    strength = sin(angle * 100.0);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 44

    angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0) + 0.5;
    float radius = 0.25 + sin(angle * 100.0) * 0.02;
    strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 45

    strength = cnoise(vUv * 10.0);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 46

    strength = step(0.0, cnoise(vUv * 10.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 47

    strength = 1.0 - abs(cnoise(vUv * 10.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 48

    strength = sin(cnoise(vUv * 10.0) * 20.0);
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 49

    strength = step(0.9, sin(cnoise(vUv * 10.0) * 20.0));
    gl_FragColor = vec4(vec3(strength), 1.0); // pattern 50

    vec3 blackColor = vec3(0.0);
    vec3 uvColor = vec3(vUv, 1.0);
    vec3 mixedColor = mix(blackColor, uvColor, strength);
    gl_FragColor = vec4(mixedColor, 1.0);
}
