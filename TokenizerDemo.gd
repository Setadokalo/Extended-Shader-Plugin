extends TextEdit

export var symbol_color: Color
export var quote_color: Color
export var bool_color: Color

export var keyword_token_color: Color
export var keyword_value_token_color: Color
export var type_token_color: Color
export var type_modifier_token_color: Color
export var editor_hint_token_color: Color
export var identifier_token_color: Color
export var number_token_color: Color
export var semicolon_token_color: Color
export var colon_token_color: Color
export var comma_token_color: Color
export var whitespace_token_color: Color
export var delim_token_color: Color
export var op_token_color: Color

var SHADER_TO_TOKENIZE = """
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
shader_type canvas_item;
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/math.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
float remapf(float val, float current_min, float current_max, float new_min, float new_max) {
	return (val - current_min) / (current_max - current_min) * (new_max - new_min) + new_min;
}
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/math.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular2d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

// jitter cell ceneters. less gives more regular pattern
uniform float cellular2d_jitter:hint_range(0.0, 1.0);

// Cellular noise (\"Worley noise\") in 2D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

// Modulo 289 without a division (only multiplications)
vec4 mod289_4(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 mod289_3(vec3 x) {
	 return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289_2(vec2 x) {
	 return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float mod289(float x) {
	 return x - floor(x * (1.0 / 289.0)) * 289.0;
}

// Modulo 7 without a division
vec3 mod7_3(vec3 x) {
	 return x - floor(x * (1.0 / 7.0)) * 7.0;
}

vec4 mod7_4(vec4 x) {
  return x - floor(x * (1.0 / 7.0)) * 7.0;
}

float permute(float x) {
	 return mod289(((x * 34.0) + 1.0) * x);
}

// Permutation polynomial: (34x^2 + x) mod 289
vec3 permute_3(vec3 x) {
	 return mod289_3((34.0 * x + 1.0) * x);
}

// Permutation polynomial: (34x^2 + x) mod 289
vec4 permute_4(vec4 x) {
  return mod289_4((34.0 * x + 1.0) * x);
}

vec4 taylorInvSqrt_4(vec4 r) {
	 return 1.79284291400159 - 0.85373472095314 * r;
}

float taylorInvSqrt(float r) {
	 return 2.79284291400159 - 1.85373472095314 * r;
}

vec2 fade_2(vec2 t) {
	 return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

vec3 fade_3(vec3 t) {
	 return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

vec4 fade_4(vec4 t) {
	return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Cellular noise, returning F1 and F2 in a vec2.
// Standard 3x3 search window for good F1 and F2 values
vec2 cellular2d(vec2 P) {
	 float K = 0.142857142857; // 1/7
	 float Ko = 0.428571428571; // 3/7

	 vec2 Pi = mod289_2(floor(P));
	 vec2 Pf = fract(P);
	 vec3 oi = vec3(-1.0, 0.0, 1.0);
	 vec3 of = vec3(-0.5, 0.5, 1.5);
	 vec3 px = permute_3(Pi.x + oi);
	 vec3 p = permute_3(px.x + Pi.y + oi); // p11, p12, p13
	 vec3 ox = fract(p*K) - Ko;
	 vec3 oy = mod7_3(floor(p*K))*K - Ko;
	 vec3 dx = Pf.x + 0.5 + cellular2d_jitter*ox;
	 vec3 dy = Pf.y - of + cellular2d_jitter*oy;
	 vec3 d1 = dx * dx + dy * dy; // d11, d12 and d13, squared
	 p = permute_3(px.y + Pi.y + oi); // p21, p22, p23
	 ox = fract(p*K) - Ko;
	 oy = mod7_3(floor(p*K))*K - Ko;
	 dx = Pf.x - 0.5 + cellular2d_jitter*ox;
	 dy = Pf.y - of + cellular2d_jitter*oy;
	 vec3 d2 = dx * dx + dy * dy; // d21, d22 and d23, squared
	 p = permute_3(px.z + Pi.y + oi); // p31, p32, p33
	 ox = fract(p*K) - Ko;
	 oy = mod7_3(floor(p*K))*K - Ko;
	 dx = Pf.x - 1.5 + cellular2d_jitter*ox;
	 dy = Pf.y - of + cellular2d_jitter*oy;
	 vec3 d3 = dx * dx + dy * dy; // d31, d32 and d33, squared
	 // Sort out the two smallest distances (F1, F2)
	 vec3 d1a = min(d1, d2);
	 d2 = max(d1, d2); // Swap to keep candidates for F2
	 d2 = min(d2, d3); // neither F1 nor F2 are now in d3
	 d1 = min(d1a, d2); // F1 is now in d1
	 d2 = max(d1a, d2); // Swap to keep candidates for F2
	 d1.xy = (d1.x < d1.y) ? d1.xy : d1.yx; // Swap if smaller
	 d1.xz = (d1.x < d1.z) ? d1.xz : d1.zx; // F1 is in d1.x
	 d1.yz = min(d1.yz, d2.yz); // F2 is now not in d2.yz
	 d1.y = min(d1.y, d1.z); // nor in  d1.z
	 d1.y = min(d1.y, d2.x); // F2 is in d1.y, we're done.
	 return sqrt(d1.xy);
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular2d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular2x2.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

// jitter cell ceneters. less gives more regular pattern
// 1.0 makes F1 wrong more often
uniform float cellular_2x2_jitter:hint_range(0.0, 1.0);

// Cellular noise (\"Worley noise\") in 2D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

// Modulo 289 without a division (only multiplications)

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Cellular noise, returning F1 and F2 in a vec2.
// Speeded up by using 2x2 search window instead of 3x3,
// at the expense of some strong pattern artifacts.
// F2 is often wrong and has sharp discontinuities.
// If you need a smooth F2, use the slower 3x3 version.
// F1 is sometimes wrong, too, but OK for most purposes.
vec2 cellular2x2(vec2 P) {
	 float K = 0.142857142857; // 1/7
	 float K2 = 0.0714285714285; // K/2

	 vec2 Pi = mod289_2(floor(P));
	 vec2 Pf = fract(P);
	 vec4 Pfx = Pf.x + vec4(-0.5, -1.5, -0.5, -1.5);
	 vec4 Pfy = Pf.y + vec4(-0.5, -0.5, -1.5, -1.5);
	 vec4 p = permute_4(Pi.x + vec4(0.0, 1.0, 0.0, 1.0));
	 p = permute_4(p + Pi.y + vec4(0.0, 0.0, 1.0, 1.0));
	 vec4 ox = mod7_4(p)*K+K2;
	 vec4 oy = mod7_4(floor(p*K))*K+K2;
	 vec4 dx = Pfx + cellular_2x2_jitter*ox;
	 vec4 dy = Pfy + cellular_2x2_jitter*oy;
	 vec4 d = dx * dx + dy * dy; // d11, d12, d21 and d22, squared
	 // Sort out the two smallest distances

// F1 Only Block (works faster of course)
	 d.xy = min(d.xy, d.zw);
	 d.x = min(d.x, d.y);
	 return vec2(sqrt(d.x)); // F1 duplicated, F2 not computed
// End of F1 Only Block

/*// F1 and F2 block
	 d.xy = (d.x < d.y) ? d.xy : d.yx; // Swap if smaller
	 d.xz = (d.x < d.z) ? d.xz : d.zx;
	 d.xw = (d.x < d.w) ? d.xw : d.wx;
	 d.y = min(d.y, d.z);
	 d.y = min(d.y, d.w);
	 return sqrt(d.xy);
*/// End of F1 and F2 block
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular2x2.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular2x2x2.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

// jitter cell ceneters. less gives more regular pattern
// 1.0 makes F1 wrong more often
// smaller gives less errors in F2
uniform float cellular_2x2x2_jitter:hint_range(0.0, 1.0);

// Cellular noise (\"Worley noise\") in 3D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Cellular noise, returning F1 and F2 in a vec2.
// Speeded up by using 2x2x2 search window instead of 3x3x3,
// at the expense of some pattern artifacts.
// F2 is often wrong and has sharp discontinuities.
// If you need a good F2, use the slower 3x3x3 version.
vec2 cellular2x2x2(vec3 P) {
	 float K = 0.142857142857; // 1/7
	 float Ko = 0.428571428571; // 1/2-K/2
	 float K2 = 0.020408163265306; // 1/(7*7)
	 float Kz = 0.166666666667; // 1/6
	 float Kzo = 0.416666666667; // 1/2-1/6*2

	 vec3 Pi = mod289_3(floor(P));
	 vec3 Pf = fract(P);
	 vec4 Pfx = Pf.x + vec4(0.0, -1.0, 0.0, -1.0);
	 vec4 Pfy = Pf.y + vec4(0.0, 0.0, -1.0, -1.0);
	 vec4 p = permute_4(Pi.x + vec4(0.0, 1.0, 0.0, 1.0));
	 p = permute_4(p + Pi.y + vec4(0.0, 0.0, 1.0, 1.0));
	 vec4 p1 = permute_4(p + Pi.z); // z+0
	 vec4 p2 = permute_4(p + Pi.z + vec4(1.0)); // z+1
	 vec4 ox1 = fract(p1*K) - Ko;
	 vec4 oy1 = mod7_4(floor(p1*K))*K - Ko;
	 vec4 oz1 = floor(p1*K2)*Kz - Kzo; // p1 < 289 guaranteed
	 vec4 ox2 = fract(p2*K) - Ko;
	 vec4 oy2 = mod7_4(floor(p2*K))*K - Ko;
	 vec4 oz2 = floor(p2*K2)*Kz - Kzo;
	 vec4 dx1 = Pfx + cellular_2x2x2_jitter*ox1;
	 vec4 dy1 = Pfy + cellular_2x2x2_jitter*oy1;
	 vec4 dz1 = Pf.z + cellular_2x2x2_jitter*oz1;
	 vec4 dx2 = Pfx + cellular_2x2x2_jitter*ox2;
	 vec4 dy2 = Pfy + cellular_2x2x2_jitter*oy2;
	 vec4 dz2 = Pf.z - 1.0 + cellular_2x2x2_jitter*oz2;
	 vec4 d1 = dx1 * dx1 + dy1 * dy1 + dz1 * dz1; // z+0
	 vec4 d2 = dx2 * dx2 + dy2 * dy2 + dz2 * dz2; // z+1

	 // Sort out the two smallest distances (F1, F2)
// Block for F1 only
	 d1 = min(d1, d2);
	 d1.xy = min(d1.xy, d1.wz);
	 d1.x = min(d1.x, d1.y);
	 return vec2(sqrt(d1.x));
//End of F1 only block
/*// Block for both F1 and F2
	 vec4 d = min(d1,d2); // F1 is now in d
	 d2 = max(d1,d2); // Make sure we keep all candidates for F2
	 d.xy = (d.x < d.y) ? d.xy : d.yx; // Swap smallest to d.x
	 d.xz = (d.x < d.z) ? d.xz : d.zx;
	 d.xw = (d.x < d.w) ? d.xw : d.wx; // F1 is now in d.x
	 d.yzw = min(d.yzw, d2.yzw); // F2 now not in d2.yzw
	 d.y = min(d.y, d.z); // nor in d.z
	 d.y = min(d.y, d.w); // nor in d.w
	 d.y = min(d.y, d2.x); // F2 is now in d.y
	 return sqrt(d.xy); // F1 and F2
*/// End Of F1 and F2 block
}


/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular2x2x2.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/classic_perlin2d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/


// GLSL textureless classic 2D noise \"cnoise\",
// with an RSL-style periodic variant \"pnoise\".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Classic Perlin noise
float cnoise2d(vec2 P) {
	 vec4 Pi = floor(vec4(P, P)) + vec4(0.0, 0.0, 1.0, 1.0);
	 vec4 Pf = fract(vec4(P, P)) - vec4(0.0, 0.0, 1.0, 1.0);
	 Pi = mod289_4(Pi); // To avoid truncation effects in permutation
	 vec4 ix = Pi.xzxz;
	 vec4 iy = Pi.yyww;
	 vec4 fx = Pf.xzxz;
	 vec4 fy = Pf.yyww;

	 vec4 i = permute_4(permute_4(ix) + iy);

	 vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
	 vec4 gy = abs(gx) - 0.5 ;
	 vec4 tx = floor(gx + 0.5);
	 gx = gx - tx;

	 vec2 g00 = vec2(gx.x,gy.x);
	 vec2 g10 = vec2(gx.y,gy.y);
	 vec2 g01 = vec2(gx.z,gy.z);
	 vec2 g11 = vec2(gx.w,gy.w);
	 
	 vec4 norm = taylorInvSqrt_4(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
	 g00 *= norm.x;
	 g01 *= norm.y;
	 g10 *= norm.z;
	 g11 *= norm.w;
	 
	 float n00 = dot(g00, vec2(fx.x, fy.x));
	 float n10 = dot(g10, vec2(fx.y, fy.y));
	 float n01 = dot(g01, vec2(fx.z, fy.z));
	 float n11 = dot(g11, vec2(fx.w, fy.w));
	 
	 vec2 fade_xy = fade_2(Pf.xy);
	 vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
	 float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
	 return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise_2(vec2 P, vec2 rep) {
	 vec4 Pi = floor(vec4(P, P)) + vec4(0.0, 0.0, 1.0, 1.0);
	 vec4 Pf = fract(vec4(P, P)) - vec4(0.0, 0.0, 1.0, 1.0);
	 Pi = mod(Pi, vec4(rep, rep)); // To create noise with explicit period
	 Pi = mod289_4(Pi); // To avoid truncation effects in permutation
	 vec4 ix = Pi.xzxz;
	 vec4 iy = Pi.yyww;
	 vec4 fx = Pf.xzxz;
	 vec4 fy = Pf.yyww;
	 
	 vec4 i = permute_4(permute_4(ix) + iy);
	 
	 vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
	 vec4 gy = abs(gx) - 0.5 ;
	 vec4 tx = floor(gx + 0.5);
	 gx = gx - tx;
	 
	 vec2 g00 = vec2(gx.x,gy.x);
	 vec2 g10 = vec2(gx.y,gy.y);
	 vec2 g01 = vec2(gx.z,gy.z);
	 vec2 g11 = vec2(gx.w,gy.w);
	 
	 vec4 norm = taylorInvSqrt_4(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
	 g00 *= norm.x;
	 g01 *= norm.y;
	 g10 *= norm.z;
	 g11 *= norm.w;

	 float n00 = dot(g00, vec2(fx.x, fy.x));
	 float n10 = dot(g10, vec2(fx.y, fy.y));
	 float n01 = dot(g01, vec2(fx.z, fy.z));
	 float n11 = dot(g11, vec2(fx.w, fy.w));
	 
	 vec2 fade_xy = fade_2(Pf.xy);
	 vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
	 float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
	 return 2.3 * n_xy;
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/classic_perlin2d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular3d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

// jitter cell ceneters. less gives more regular pattern
uniform float cellular_3d_jitter:hint_range(0.0, 1.0);

// Cellular noise (\"Worley noise\") in 3D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Cellular noise, returning F1 and F2 in a vec2.
// 3x3x3 search region for good F2 everywhere, but a lot
// slower than the 2x2x2 version.
// The code below is a bit scary even to its author,
// but it has at least half decent performance on a
// modern GPU. In any case, it beats any software
// implementation of Worley noise hands down.

vec2 cellular3d(vec3 P) {
	 float K = 0.142857142857; // 1/7
	 float Ko = 0.428571428571; // 1/2-K/2
	 float K2 = 0.020408163265306; // 1/(7*7)
	 float Kz = 0.166666666667; // 1/6
	 float Kzo = 0.416666666667; // 1/2-1/6*2
	 
	 vec3 Pi = mod289_3(floor(P));
	 vec3 Pf = fract(P) - 0.5;
	 
	 vec3 Pfx = Pf.x + vec3(1.0, 0.0, -1.0);
	 vec3 Pfy = Pf.y + vec3(1.0, 0.0, -1.0);
	 vec3 Pfz = Pf.z + vec3(1.0, 0.0, -1.0);
	 
	 vec3 p = permute_3(Pi.x + vec3(-1.0, 0.0, 1.0));
	 vec3 p1 = permute_3(p + Pi.y - 1.0);
	 vec3 p2 = permute_3(p + Pi.y);
	 vec3 p3 = permute_3(p + Pi.y + 1.0);
	 
	 vec3 p11 = permute_3(p1 + Pi.z - 1.0);
	 vec3 p12 = permute_3(p1 + Pi.z);
	 vec3 p13 = permute_3(p1 + Pi.z + 1.0);
	 
	 vec3 p21 = permute_3(p2 + Pi.z - 1.0);
	 vec3 p22 = permute_3(p2 + Pi.z);
	 vec3 p23 = permute_3(p2 + Pi.z + 1.0);
	 
	 vec3 p31 = permute_3(p3 + Pi.z - 1.0);
	 vec3 p32 = permute_3(p3 + Pi.z);
	 vec3 p33 = permute_3(p3 + Pi.z + 1.0);
	 
	 vec3 ox11 = fract(p11*K) - Ko;
	 vec3 oy11 = mod7_3(floor(p11*K))*K - Ko;
	 vec3 oz11 = floor(p11*K2)*Kz - Kzo; // p11 < 289 guaranteed
	 
	 vec3 ox12 = fract(p12*K) - Ko;
	 vec3 oy12 = mod7_3(floor(p12*K))*K - Ko;
	 vec3 oz12 = floor(p12*K2)*Kz - Kzo;
	 
	 vec3 ox13 = fract(p13*K) - Ko;
	 vec3 oy13 = mod7_3(floor(p13*K))*K - Ko;
	 vec3 oz13 = floor(p13*K2)*Kz - Kzo;
	 
	 vec3 ox21 = fract(p21*K) - Ko;
	 vec3 oy21 = mod7_3(floor(p21*K))*K - Ko;
	 vec3 oz21 = floor(p21*K2)*Kz - Kzo;
	 
	 vec3 ox22 = fract(p22*K) - Ko;
	 vec3 oy22 = mod7_3(floor(p22*K))*K - Ko;
	 vec3 oz22 = floor(p22*K2)*Kz - Kzo;
	 
	 vec3 ox23 = fract(p23*K) - Ko;
	 vec3 oy23 = mod7_3(floor(p23*K))*K - Ko;
	 vec3 oz23 = floor(p23*K2)*Kz - Kzo;
	 
	 vec3 ox31 = fract(p31*K) - Ko;
	 vec3 oy31 = mod7_3(floor(p31*K))*K - Ko;
	 vec3 oz31 = floor(p31*K2)*Kz - Kzo;
	 
	 vec3 ox32 = fract(p32*K) - Ko;
	 vec3 oy32 = mod7_3(floor(p32*K))*K - Ko;
	 vec3 oz32 = floor(p32*K2)*Kz - Kzo;
	 
	 vec3 ox33 = fract(p33*K) - Ko;
	 vec3 oy33 = mod7_3(floor(p33*K))*K - Ko;
	 vec3 oz33 = floor(p33*K2)*Kz - Kzo;
	 
	 vec3 dx11 = Pfx + cellular_3d_jitter*ox11;
	 vec3 dy11 = Pfy.x + cellular_3d_jitter*oy11;
	 vec3 dz11 = Pfz.x + cellular_3d_jitter*oz11;
	 
	 vec3 dx12 = Pfx + cellular_3d_jitter*ox12;
	 vec3 dy12 = Pfy.x + cellular_3d_jitter*oy12;
	 vec3 dz12 = Pfz.y + cellular_3d_jitter*oz12;
	 
	 vec3 dx13 = Pfx + cellular_3d_jitter*ox13;
	 vec3 dy13 = Pfy.x + cellular_3d_jitter*oy13;
	 vec3 dz13 = Pfz.z + cellular_3d_jitter*oz13;
	 
	 vec3 dx21 = Pfx + cellular_3d_jitter*ox21;
	 vec3 dy21 = Pfy.y + cellular_3d_jitter*oy21;
	 vec3 dz21 = Pfz.x + cellular_3d_jitter*oz21;
	 
	 vec3 dx22 = Pfx + cellular_3d_jitter*ox22;
	 vec3 dy22 = Pfy.y + cellular_3d_jitter*oy22;
	 vec3 dz22 = Pfz.y + cellular_3d_jitter*oz22;
	 
	 vec3 dx23 = Pfx + cellular_3d_jitter*ox23;
	 vec3 dy23 = Pfy.y + cellular_3d_jitter*oy23;
	 vec3 dz23 = Pfz.z + cellular_3d_jitter*oz23;
	 
	 vec3 dx31 = Pfx + cellular_3d_jitter*ox31;
	 vec3 dy31 = Pfy.z + cellular_3d_jitter*oy31;
	 vec3 dz31 = Pfz.x + cellular_3d_jitter*oz31;
	 
	 vec3 dx32 = Pfx + cellular_3d_jitter*ox32;
	 vec3 dy32 = Pfy.z + cellular_3d_jitter*oy32;
	 vec3 dz32 = Pfz.y + cellular_3d_jitter*oz32;
	 
	 vec3 dx33 = Pfx + cellular_3d_jitter*ox33;
	 vec3 dy33 = Pfy.z + cellular_3d_jitter*oy33;
	 vec3 dz33 = Pfz.z + cellular_3d_jitter*oz33;
	 
	 vec3 d11 = dx11 * dx11 + dy11 * dy11 + dz11 * dz11;
	 vec3 d12 = dx12 * dx12 + dy12 * dy12 + dz12 * dz12;
	 vec3 d13 = dx13 * dx13 + dy13 * dy13 + dz13 * dz13;
	 vec3 d21 = dx21 * dx21 + dy21 * dy21 + dz21 * dz21;
	 vec3 d22 = dx22 * dx22 + dy22 * dy22 + dz22 * dz22;
	 vec3 d23 = dx23 * dx23 + dy23 * dy23 + dz23 * dz23;
	 vec3 d31 = dx31 * dx31 + dy31 * dy31 + dz31 * dz31;
	 vec3 d32 = dx32 * dx32 + dy32 * dy32 + dz32 * dz32;
	 vec3 d33 = dx33 * dx33 + dy33 * dy33 + dz33 * dz33;
	 
	 // Sort out the two smallest distances (F1, F2)
// F1 only block
	 vec3 d1 = min(min(d11,d12), d13);
	 vec3 d2 = min(min(d21,d22), d23);
	 vec3 d3 = min(min(d31,d32), d33);
	 vec3 d = min(min(d1,d2), d3);
	 d.x = min(min(d.x,d.y),d.z);
	 return vec2(sqrt(d.x)); // F1 duplicated, no F2 computed
// End of F1 only block
/*// F1 and F2 block
	 vec3 d1a = min(d11, d12);
	 d12 = max(d11, d12);
	 d11 = min(d1a, d13); // Smallest now not in d12 or d13
	 d13 = max(d1a, d13);
	 d12 = min(d12, d13); // 2nd smallest now not in d13
	 vec3 d2a = min(d21, d22);
	 d22 = max(d21, d22);
	 d21 = min(d2a, d23); // Smallest now not in d22 or d23
	 d23 = max(d2a, d23);
	 d22 = min(d22, d23); // 2nd smallest now not in d23
	 vec3 d3a = min(d31, d32);
	 d32 = max(d31, d32);
	 d31 = min(d3a, d33); // Smallest now not in d32 or d33
	 d33 = max(d3a, d33);
	 d32 = min(d32, d33); // 2nd smallest now not in d33
	 vec3 da = min(d11, d21);
	 d21 = max(d11, d21);
	 d11 = min(da, d31); // Smallest now in d11
	 d31 = max(da, d31); // 2nd smallest now not in d31
	 d11.xy = (d11.x < d11.y) ? d11.xy : d11.yx;
	 d11.xz = (d11.x < d11.z) ? d11.xz : d11.zx; // d11.x now smallest
	 d12 = min(d12, d21); // 2nd smallest now not in d21
	 d12 = min(d12, d22); // nor in d22
	 d12 = min(d12, d31); // nor in d31
	 d12 = min(d12, d32); // nor in d32
	 d11.yz = min(d11.yz,d12.xy); // nor in d12.yz
	 d11.y = min(d11.y,d12.z); // Only two more to go
	 d11.y = min(d11.y,d11.z); // Done! (Phew!)
	 return sqrt(d11.xy); // F1, F2
*/// End of F1 and F2 block
}


/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/cellular3d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/classic_perlin4d.extshader" ****/

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/classic_perlin4d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/classic_perlin3d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/


// GLSL textureless classic 3D noise \"cnoise\",
// with an RSL-style periodic variant \"pnoise\".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-10-11
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Classic Perlin noise
float cnoise(vec3 P) {
	 vec3 Pi0 = floor(P); // Integer part for indexing
	 vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
	 Pi0 = mod289_3(Pi0);
	 Pi1 = mod289_3(Pi1);
	 vec3 Pf0 = fract(P); // Fractional part for interpolation
	 vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
	 vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
	 vec4 iy = vec4(Pi0.yy, Pi1.yy);
	 vec4 iz0 = vec4(Pi0.z);
	 vec4 iz1 = vec4(Pi1.z);
	 
	 vec4 ixy = permute_4(permute_4(ix) + iy);
	 vec4 ixy0 = permute_4(ixy + iz0);
	 vec4 ixy1 = permute_4(ixy + iz1);
	 
	 vec4 gx0 = ixy0 * (1.0 / 7.0);
	 vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
	 gx0 = fract(gx0);
	 vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
	 vec4 sz0 = step(gz0, vec4(0.0));
	 gx0 -= sz0 * (step(0.0, gx0) - 0.5);
	 gy0 -= sz0 * (step(0.0, gy0) - 0.5);
	 
	 vec4 gx1 = ixy1 * (1.0 / 7.0);
	 vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
	 gx1 = fract(gx1);
	 vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
	 vec4 sz1 = step(gz1, vec4(0.0));
	 gx1 -= sz1 * (step(0.0, gx1) - 0.5);
	 gy1 -= sz1 * (step(0.0, gy1) - 0.5);
	 
	 vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
	 vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
	 vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
	 vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
	 vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
	 vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
	 vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
	 vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);
	 
	 vec4 norm0 = taylorInvSqrt_4(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
	 g000 *= norm0.x;
	 g010 *= norm0.y;
	 g100 *= norm0.z;
	 g110 *= norm0.w;
	 vec4 norm1 = taylorInvSqrt_4(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
	 g001 *= norm1.x;
	 g011 *= norm1.y;
	 g101 *= norm1.z;
	 g111 *= norm1.w;
	 
	 float n000 = dot(g000, Pf0);
	 float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
	 float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
	 float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
	 float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
	 float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
	 float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
	 float n111 = dot(g111, Pf1);
	 
	 vec3 fade_xyz = fade_3(Pf0);
	 vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
	 vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
	 float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
	 return 2.2 * n_xyz;
}

// Classic Perlin noise, periodic variant
float pnoise_3(vec3 P, vec3 rep) {
	 vec3 Pi0 = mod(floor(P), rep); // Integer part, modulo period
	 vec3 Pi1 = mod(Pi0 + vec3(1.0), rep); // Integer part + 1, mod period
	 Pi0 = mod289_3(Pi0);
	 Pi1 = mod289_3(Pi1);
	 vec3 Pf0 = fract(P); // Fractional part for interpolation
	 vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
	 vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
	 vec4 iy = vec4(Pi0.yy, Pi1.yy);
	 vec4 iz0 = vec4(Pi0.z);
	 vec4 iz1 = vec4(Pi1.z);
	 
	 vec4 ixy = permute_4(permute_4(ix) + iy);
	 vec4 ixy0 = permute_4(ixy + iz0);
	 vec4 ixy1 = permute_4(ixy + iz1);
	 
	 vec4 gx0 = ixy0 * (1.0 / 7.0);
	 vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
	 gx0 = fract(gx0);
	 vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
	 vec4 sz0 = step(gz0, vec4(0.0));
	 gx0 -= sz0 * (step(0.0, gx0) - 0.5);
	 gy0 -= sz0 * (step(0.0, gy0) - 0.5);
	 
	 vec4 gx1 = ixy1 * (1.0 / 7.0);
	 vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
	 gx1 = fract(gx1);
	 vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
	 vec4 sz1 = step(gz1, vec4(0.0));
	 gx1 -= sz1 * (step(0.0, gx1) - 0.5);
	 gy1 -= sz1 * (step(0.0, gy1) - 0.5);
	 
	 vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
	 vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
	 vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
	 vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
	 vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
	 vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
	 vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
	 vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);
	 
	 vec4 norm0 = taylorInvSqrt_4(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
	 g000 *= norm0.x;
	 g010 *= norm0.y;
	 g100 *= norm0.z;
	 g110 *= norm0.w;
	 vec4 norm1 = taylorInvSqrt_4(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
	 g001 *= norm1.x;
	 g011 *= norm1.y;
	 g101 *= norm1.z;
	 g111 *= norm1.w;
	 
	 float n000 = dot(g000, Pf0);
	 float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
	 float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
	 float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
	 float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
	 float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
	 float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
	 float n111 = dot(g111, Pf1);
	 
	 vec3 fade_xyz = fade_3(Pf0);
	 vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
	 vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
	 float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
	 return 2.2 * n_xyz;
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/classic_perlin3d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/psrdnoise.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/


// vec3  psrdnoise(vec2 pos, vec2 per, float rot)
// vec3  psdnoise(vec2 pos, vec2 per)
// float psrnoise(vec2 pos, vec2 per, float rot)
// float psnoise(vec2 pos, vec2 per)
// vec3  srdnoise(vec2 pos, float rot)
// vec3  sdnoise(vec2 pos)
// float srnoise(vec2 pos, float rot)
// float snoise(vec2 pos)
//
// Periodic (tiling) 2-D simplex noise (hexagonal lattice gradient noise)
// with rotating gradients and analytic derivatives.
// Variants also without the derivative (no \"d\" in the name), without
// the tiling property (no \"p\" in the name) and without the rotating
// gradients (no \"r\" in the name).
//
// This is (yet) another variation on simplex noise. It's similar to the
// version presented by Ken Perlin, but the grid is axis-aligned and
// slightly stretched in the y direction to permit rectangular tiling.
//
// The noise can be made to tile seamlessly to any integer period in x and
// any even integer period in y. Odd periods may be specified for y, but
// then the actual tiling period will be twice that number.
//
// The rotating gradients give the appearance of a swirling motion, and can
// serve a similar purpose for animation as motion along z in 3-D noise.
// The rotating gradients in conjunction with the analytic derivatives
// can make \"flow noise\" effects as presented by Perlin and Neyret.
//
// vec3 {p}s{r}dnoise(vec2 pos {, vec2 per} {, float rot})
// \"pos\" is the input (x,y) coordinate
// \"per\" is the x and y period, where per.x is a positive integer
//    and per.y is a positive even integer
// \"rot\" is the angle to rotate the gradients (any float value,
//    where 0.0 is no rotation and 1.0 is one full turn)
// The first component of the 3-element return vector is the noise value.
// The second and third components are the x and y partial derivatives.
//
// float {p}s{r}noise(vec2 pos {, vec2 per} {, float rot})
// \"pos\" is the input (x,y) coordinate
// \"per\" is the x and y period, where per.x is a positive integer
//    and per.y is a positive even integer
// \"rot\" is the angle to rotate the gradients (any float value,
//    where 0.0 is no rotation and 1.0 is one full turn)
// The return value is the noise value.
// Partial derivatives are not computed, making these functions faster.
//
// Author: Stefan Gustavson (stefan.gustavson@gmail.com)
// Version 2016-05-10.
//
// Many thanks to Ian McEwan of Ashima Arts for the
// idea of using a permutation polynomial.
//
// Copyright (c) 2016 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

//
// TODO: One-pixel wide artefacts used to occur due to precision issues with
// the gradient indexing. This is specific to this variant of noise, because
// one axis of the simplex grid is perfectly aligned with the input x axis.
// The errors were rare, and they are now very unlikely to ever be visible
// after a quick fix was introduced: a small offset is added to the y coordinate.
// A proper fix would involve using round() instead of floor() in selected
// places, but the quick fix works fine.
// (If you run into problems with this, please let me know.)
//

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Hashed 2-D gradients with an extra rotation.
// (The constant 0.0243902439 is 1/41)
vec2 rgrad2(vec2 p, float rot) {
/*// Map from a line to a diamond such that a shift maps to a rotation.
	float u = permute(permute(p.x) + p.y) * 0.0243902439 + rot; // Rotate by shift
	u = 4.0 * fract(u) - 2.0;
	// (This vector could be normalized, exactly or approximately.)
	return vec2(abs(u)-1.0, abs(abs(u+1.0)-2.0)-1.0);
*/
// For more isotropic gradients, sin/cos can be used instead.
	float u = permute(permute(p.x) + p.y) * 0.0243902439 + rot; // Rotate by shift
	u = fract(u) * 6.28318530718; // 2*pi
	return vec2(cos(u), sin(u));
}

//
// 2-D tiling simplex noise with rotating gradients and analytical derivative.
// The first component of the 3-element return vector is the noise value,
// and the second and third components are the x and y partial derivatives.
//
vec3 psrdnoise(vec2 pos, vec2 per, float rot) {
	 // Hack: offset y slightly to hide some rare artifacts
	 pos.y += 0.01;
	 // Skew to hexagonal grid
	 vec2 uv = vec2(pos.x + pos.y*0.5, pos.y);
	 
	 vec2 i0 = floor(uv);
	 vec2 f0 = fract(uv);
	 // Traversal order
	 vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	 
	 // Unskewed grid points in (x,y) space
	 vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);
	 vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
	 vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);
	 
	 // Integer grid point indices in (u,v) space
	 i1 = i0 + i1;
	 vec2 i2 = i0 + vec2(1.0, 1.0);
	 
	 // Vectors in unskewed (x,y) coordinates from
	 // each of the simplex corners to the evaluation point
	 vec2 d0 = pos - p0;
	 vec2 d1 = pos - p1;
	 vec2 d2 = pos - p2;
	 
	 // Wrap i0, i1 and i2 to the desired period before gradient hashing:
	 // wrap points in (x,y), map to (u,v)
	 vec3 xw = mod(vec3(p0.x, p1.x, p2.x), per.x);
	 vec3 yw = mod(vec3(p0.y, p1.y, p2.y), per.y);
	 vec3 iuw = xw + 0.5 * yw;
	 vec3 ivw = yw;
	 
	 // Create gradients from indices
	 vec2 g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
	 vec2 g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
	 vec2 g2 = rgrad2(vec2(iuw.z, ivw.z), rot);
	 
	 // Gradients dot vectors to corresponding corners
	 // (The derivatives of this are simply the gradients)
	 vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));
	 
	 // Radial weights from corners
	 // 0.8 is the square of 2/sqrt(5), the distance from
	 // a grid point to the nearest simplex boundary
	 vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));
	 
	 // Partial derivatives for analytical gradient computation
	 vec3 dtdx = -2.0 * vec3(d0.x, d1.x, d2.x);
	 vec3 dtdy = -2.0 * vec3(d0.y, d1.y, d2.y);
	 
	 // Set influence of each surflet to zero outside radius sqrt(0.8)
	 if (t.x < 0.0) {
		  dtdx.x = 0.0;
		  dtdy.x = 0.0;
		  t.x = 0.0;
	 }
	 if (t.y < 0.0) {
		  dtdx.y = 0.0;
		  dtdy.y = 0.0;
		  t.y = 0.0;
	 }
	 if (t.z < 0.0) {
		  dtdx.z = 0.0;
		  dtdy.z = 0.0;
		  t.z = 0.0;
	 }
	 
	 // Fourth power of t (and third power for derivative)
	 vec3 t2 = t * t;
	 vec3 t4 = t2 * t2;
	 vec3 t3 = t2 * t;
	 
	 // Final noise value is:
	 // sum of ((radial weights) times (gradient dot vector from corner))
	 float n = dot(t4, w);
	 
	 // Final analytical derivative (gradient of a sum of scalar products)
	 vec2 dt0 = vec2(dtdx.x, dtdy.x) * 4.0 * t3.x;
	 vec2 dn0 = t4.x * g0 + dt0 * w.x;
	 vec2 dt1 = vec2(dtdx.y, dtdy.y) * 4.0 * t3.y;
	 vec2 dn1 = t4.y * g1 + dt1 * w.y;
	 vec2 dt2 = vec2(dtdx.z, dtdy.z) * 4.0 * t3.z;
	 vec2 dn2 = t4.z * g2 + dt2 * w.z;
	 
	 return 11.0*vec3(n, dn0 + dn1 + dn2);
}

//
// 2-D tiling simplex noise with fixed gradients
// and analytical derivative.
// This function is implemented as a wrapper to \"psrdnoise\",
// at the minimal cost of three extra additions.
//
vec3 psdnoise(vec2 pos, vec2 per) {
	 return psrdnoise(pos, per, 0.0);
}

//
// 2-D tiling simplex noise with rotating gradients,
// but without the analytical derivative.
//
float psrnoise(vec2 pos, vec2 per, float rot) {
	 // Offset y slightly to hide some rare artifacts
	 pos.y += 0.001;
	 // Skew to hexagonal grid
	 vec2 uv = vec2(pos.x + pos.y*0.5, pos.y);
	 
	 vec2 i0 = floor(uv);
	 vec2 f0 = fract(uv);
	 // Traversal order
	 vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	 
	 // Unskewed grid points in (x,y) space
	 vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);
	 vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
	 vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);
	 
	 // Integer grid point indices in (u,v) space
	 i1 = i0 + i1;
	 vec2 i2 = i0 + vec2(1.0, 1.0);
	 
	 // Vectors in unskewed (x,y) coordinates from
	 // each of the simplex corners to the evaluation point
	 vec2 d0 = pos - p0;
	 vec2 d1 = pos - p1;
	 vec2 d2 = pos - p2;
	 
	 // Wrap i0, i1 and i2 to the desired period before gradient hashing:
	 // wrap points in (x,y), map to (u,v)
	 vec3 xw = mod(vec3(p0.x, p1.x, p2.x), per.x);
	 vec3 yw = mod(vec3(p0.y, p1.y, p2.y), per.y);
	 vec3 iuw = xw + 0.5 * yw;
	 vec3 ivw = yw;
	 
	 // Create gradients from indices
	 vec2 g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
	 vec2 g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
	 vec2 g2 = rgrad2(vec2(iuw.z, ivw.z), rot);
	 
	 // Gradients dot vectors to corresponding corners
	 // (The derivatives of this are simply the gradients)
	 vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));
	 
	 // Radial weights from corners
	 // 0.8 is the square of 2/sqrt(5), the distance from
	 // a grid point to the nearest simplex boundary
	 vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));
	 
	 // Set influence of each surflet to zero outside radius sqrt(0.8)
	 t = max(t, vec3(0.0));
	 
	 // Fourth power of t
	 vec3 t2 = t * t;
	 vec3 t4 = t2 * t2;
	 
	 // Final noise value is:
	 // sum of ((radial weights) times (gradient dot vector from corner))
	 float n = dot(t4, w);
	 
	 // Rescale to cover the range [-1,1] reasonably well
	 return 11.0*n;
}

//
// 2-D tiling simplex noise with fixed gradients,
// without the analytical derivative.
// This function is implemented as a wrapper to \"psrnoise\",
// at the minimal cost of three extra additions.
//
float psnoise(vec2 pos, vec2 per) {
	return psrnoise(pos, per, 0.0);
}

//
// 2-D non-tiling simplex noise with rotating gradients and analytical derivative.
// The first component of the 3-element return vector is the noise value,
// and the second and third components are the x and y partial derivatives.
//
vec3 srdnoise(vec2 pos, float rot) {
	 // Offset y slightly to hide some rare artifacts
	 pos.y += 0.001;
	 // Skew to hexagonal grid
	 vec2 uv = vec2(pos.x + pos.y*0.5, pos.y);
	 
	 vec2 i0 = floor(uv);
	 vec2 f0 = fract(uv);
	 // Traversal order
	 vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	 
	 // Unskewed grid points in (x,y) space
	 vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);
	 vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
	 vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);
	 
	 // Integer grid point indices in (u,v) space
	 i1 = i0 + i1;
	 vec2 i2 = i0 + vec2(1.0, 1.0);
	 
	 // Vectors in unskewed (x,y) coordinates from
	 // each of the simplex corners to the evaluation point
	 vec2 d0 = pos - p0;
	 vec2 d1 = pos - p1;
	 vec2 d2 = pos - p2;
	 
	 vec3 x = vec3(p0.x, p1.x, p2.x);
	 vec3 y = vec3(p0.y, p1.y, p2.y);
	 vec3 iuw = x + 0.5 * y;
	 vec3 ivw = y;
	 
	 // Avoid precision issues in permutation
	 iuw = mod289_3(iuw);
	 ivw = mod289_3(ivw);
	 
	 // Create gradients from indices
	 vec2 g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
	 vec2 g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
	 vec2 g2 = rgrad2(vec2(iuw.z, ivw.z), rot);
	 
	 // Gradients dot vectors to corresponding corners
	 // (The derivatives of this are simply the gradients)
	 vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));
	 
	 // Radial weights from corners
	 // 0.8 is the square of 2/sqrt(5), the distance from
	 // a grid point to the nearest simplex boundary
	 vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));
	 
	 // Partial derivatives for analytical gradient computation
	 vec3 dtdx = -2.0 * vec3(d0.x, d1.x, d2.x);
	 vec3 dtdy = -2.0 * vec3(d0.y, d1.y, d2.y);
	 
	 // Set influence of each surflet to zero outside radius sqrt(0.8)
	 if (t.x < 0.0) {
		  dtdx.x = 0.0;
		  dtdy.x = 0.0;
		  t.x = 0.0;
	 }
	 if (t.y < 0.0) {
		  dtdx.y = 0.0;
		  dtdy.y = 0.0;
		  t.y = 0.0;
	 }
	 if (t.z < 0.0) {
		  dtdx.z = 0.0;
		  dtdy.z = 0.0;
		  t.z = 0.0;
	 }
	 
	 // Fourth power of t (and third power for derivative)
	 vec3 t2 = t * t;
	 vec3 t4 = t2 * t2;
	 vec3 t3 = t2 * t;
	 
	 // Final noise value is:
	 // sum of ((radial weights) times (gradient dot vector from corner))
	 float n = dot(t4, w);
	 
	 // Final analytical derivative (gradient of a sum of scalar products)
	 vec2 dt0 = vec2(dtdx.x, dtdy.x) * 4.0 * t3.x;
	 vec2 dn0 = t4.x * g0 + dt0 * w.x;
	 vec2 dt1 = vec2(dtdx.y, dtdy.y) * 4.0 * t3.y;
	 vec2 dn1 = t4.y * g1 + dt1 * w.y;
	 vec2 dt2 = vec2(dtdx.z, dtdy.z) * 4.0 * t3.z;
	 vec2 dn2 = t4.z * g2 + dt2 * w.z;
	 
	 return 11.0*vec3(n, dn0 + dn1 + dn2);
}

//
// 2-D non-tiling simplex noise with fixed gradients and analytical derivative.
// This function is implemented as a wrapper to \"srdnoise\",
// at the minimal cost of three extra additions.
//
vec3 sdnoise(vec2 pos) {
	 return srdnoise(pos, 0.0);
}

//
// 2-D non-tiling simplex noise with rotating gradients,
// without the analytical derivative.
//
float srnoise(vec2 pos, float rot) {
	 // Offset y slightly to hide some rare artifacts
	 pos.y += 0.001;
	 // Skew to hexagonal grid
	 vec2 uv = vec2(pos.x + pos.y*0.5, pos.y);
	 
	 vec2 i0 = floor(uv);
	 vec2 f0 = fract(uv);
	 // Traversal order
	 vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	 
	 // Unskewed grid points in (x,y) space
	 vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);
	 vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
	 vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);
	 
	 // Integer grid point indices in (u,v) space
	 i1 = i0 + i1;
	 vec2 i2 = i0 + vec2(1.0, 1.0);
	 
	 // Vectors in unskewed (x,y) coordinates from
	 // each of the simplex corners to the evaluation point
	 vec2 d0 = pos - p0;
	 vec2 d1 = pos - p1;
	 vec2 d2 = pos - p2;
	 
	 // Wrap i0, i1 and i2 to the desired period before gradient hashing:
	 // wrap points in (x,y), map to (u,v)
	 vec3 x = vec3(p0.x, p1.x, p2.x);
	 vec3 y = vec3(p0.y, p1.y, p2.y);
	 vec3 iuw = x + 0.5 * y;
	 vec3 ivw = y;
	 
	 // Avoid precision issues in permutation
	 iuw = mod289_3(iuw);
	 ivw = mod289_3(ivw);
	 
	 // Create gradients from indices
	 vec2 g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
	 vec2 g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
	 vec2 g2 = rgrad2(vec2(iuw.z, ivw.z), rot);
	 
	 // Gradients dot vectors to corresponding corners
	 // (The derivatives of this are simply the gradients)
	 vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));
	 
	 // Radial weights from corners
	 // 0.8 is the square of 2/sqrt(5), the distance from
	 // a grid point to the nearest simplex boundary
	 vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));
	 
	 // Set influence of each surflet to zero outside radius sqrt(0.8)
	 t = max(t, vec3(0.0));
	 
	 // Fourth power of t
	 vec3 t2 = t * t;
	 vec3 t4 = t2 * t2;
	 
	 // Final noise value is:
	 // sum of ((radial weights) times (gradient dot vector from corner))
	 float n = dot(t4, w);
	 
	 // Rescale to cover the range [-1,1] reasonably well
	 return 11.0*n;
}

//
// 2-D non-tiling simplex noise with fixed gradients,
// without the analytical derivative.
// This function is implemented as a wrapper to \"srnoise\",
// at the minimal cost of three extra additions.
// Note: if this kind of noise is all you want, there are faster
// GLSL implementations of non-tiling simplex noise out there.
// This one is included mainly for completeness and compatibility
// with the other functions in the file.
//
float snoise(vec2 pos) {
	 return srnoise(pos, 0.0);
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/psrdnoise.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex2d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
// 

float snoise2d(vec2 v) {
	 vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
						0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
					  -0.577350269189626,  // -1.0 + 2.0 * C.x
						0.024390243902439); // 1.0 / 41.0
	 // First corner
	 vec2 i  = floor(v + dot(v, C.yy) );
	 vec2 x0 = v -   i + dot(i, C.xx);
	 
	 // Other corners
	 vec2 i1;
	 //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
	 //i1.y = 1.0 - i1.x;
	 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	 // x0 = x0 - 0.0 + 0.0 * C.xx ;
	 // x1 = x0 - i1 + 1.0 * C.xx ;
	 // x2 = x0 - 1.0 + 2.0 * C.xx ;
	 vec4 x12 = vec4(x0.xy, x0.xy) + C.xxzz;
	 x12.xy -= i1;
	 
	 // Permutations
	 i = mod289_2(i); // Avoid truncation effects in permutation
	 vec3 p = permute_3( permute_3( i.y + vec3(0.0, i1.y, 1.0 ))
	 	+ i.x + vec3(0.0, i1.x, 1.0 ));
	 
	 vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), vec3(0.0));
	 m = m*m ;
	 m = m*m ;
	 
	 // Gradients: 41 points uniformly over a line, mapped onto a diamond.
	 // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
	 
	 vec3 x = 2.0 * fract(p * C.www) - 1.0;
	 vec3 h = abs(x) - 0.5;
	 vec3 ox = floor(x + 0.5);
	 vec3 a0 = x - ox;
	 
	 // Normalise gradients implicitly by scaling m
	 // Approximation of: m *= inversesqrt( a0*a0 + h*h );
	 m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
	 
	 // Compute final noise value at P
	 vec3 g;
	 g.x  = a0.x  * x0.x  + h.x  * x0.y;
	 g.yz = a0.yz * x12.xz + h.yz * x12.yw;
	 return 130.0 * dot(m, g);
}


/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex2d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3dgrad.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Description : Array and textureless GLSL 2D/3D/4D simplex 
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
// 

float snoise3dgrad(vec3 v, out vec3 gradient) {
	 vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
	 vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
	 
	 // First corner
	 vec3 i  = floor(v + dot(v, vec3(C.y)) );
	 vec3 x0 =   v - i + dot(i, vec3(C.x)) ;
	 
	 // Other corners
	 vec3 g = step(x0.yzx, x0.xyz);
	 vec3 l = 1.0 - g;
	 vec3 i1 = min( g.xyz, l.zxy );
	 vec3 i2 = max( g.xyz, l.zxy );
	 
	 //   x0 = x0 - 0.0 + 0.0 * C.xxx;
	 //   x1 = x0 - i1  + 1.0 * C.xxx;
	 //   x2 = x0 - i2  + 2.0 * C.xxx;
	 //   x3 = x0 - 1.0 + 3.0 * C.xxx;
	 vec3 x1 = x0 - i1 + vec3(C.x);
	 vec3 x2 = x0 - i2 + vec3(C.y); // 2.0*C.x = 1/3 = C.y
	 vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
	 
	 // Permutations
	 i = mod289_3(i); 
	 vec4 p = permute_4( permute_4( permute_4( 
	 		 i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
	 		+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
	 		+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
	 
	 // Gradients: 7x7 points over a square, mapped onto an octahedron.
	 // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
	 float n_ = 0.142857142857; // 1.0/7.0
	 vec3  ns = n_ * D.wyz - D.xzx;
	 
	 vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
	 
	 vec4 x_ = floor(j * ns.z);
	 vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
	 
	 vec4 x = x_ *ns.x + vec4(ns.y);
	 vec4 y = y_ *ns.x + vec4(ns.y);
	 vec4 h = 1.0 - abs(x) - abs(y);
	 
	 vec4 b0 = vec4( x.xy, y.xy );
	 vec4 b1 = vec4( x.zw, y.zw );
	 
	 //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
	 //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
	 vec4 s0 = floor(b0)*2.0 + 1.0;
	 vec4 s1 = floor(b1)*2.0 + 1.0;
	 vec4 sh = -step(h, vec4(0.0));
	 
	 vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy ;
	 vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww ;
	 
	 vec3 p0 = vec3(a0.xy,h.x);
	 vec3 p1 = vec3(a0.zw,h.y);
	 vec3 p2 = vec3(a1.xy,h.z);
	 vec3 p3 = vec3(a1.zw,h.w);
	 
	 //Normalise gradients
	 vec4 norm = taylorInvSqrt_4(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
	 p0 *= norm.x;
	 p1 *= norm.y;
	 p2 *= norm.z;
	 p3 *= norm.w;
	 
	 // Mix final noise value
	 vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), vec4(0.0));
	 vec4 m2 = m * m;
	 vec4 m4 = m2 * m2;
	 vec4 pdotx = vec4(dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3));
	 
	 // Determine noise gradient
	 vec4 temp = m2 * m * pdotx;
	 gradient = -8.0 * (temp.x * x0 + temp.y * x1 + temp.z * x2 + temp.w * x3);
	 gradient += m4.x * p0 + m4.y * p1 + m4.z * p2 + m4.w * p3;
	 gradient *= 42.0;
	 
	 return 22.0 * dot(m4, pdotx);
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3dgrad.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex4d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Description : Array and textureless GLSL 2D/3D/4D simplex 
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
// 

vec4 grad4(float j, vec4 ip) {
	vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
	vec4 p, s;

	p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
	p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
	s = vec4(lessThan(p, vec4(0.0)));
	p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

	return p;
}

float snoise4d(vec4 v) {
	 vec4 C = vec4( 0.138196601125011,  // (5 - sqrt(5))/20  G4
						  0.276393202250021,  // 2 * G4
						  0.414589803375032,  // 3 * G4
						 -0.447213595499958); // -1 + 4 * G4
	 
	 // First corner
	 vec4 i  = floor(v + dot(v, vec4(0.309016994374947451)) ); //// (sqrt(5) - 1)/4
	 vec4 x0 = v -   i + dot(i, C.xxxx);
	 
	 // Other corners
	 
	 // Rank sorting originally contributed by Bill Licea-Kane, AMD (formerly ATI)
	 vec4 i0;
	 vec3 isX = step( x0.yzw, x0.xxx );
	 vec3 isYZ = step( x0.zww, x0.yyz );
	 //  i0.x = dot( isX, vec3( 1.0 ) );
	 i0.x = isX.x + isX.y + isX.z;
	 i0.yzw = 1.0 - isX;
	 //  i0.y += dot( isYZ.xy, vec2( 1.0 ) );
	 i0.y += isYZ.x + isYZ.y;
	 i0.zw += 1.0 - isYZ.xy;
	 i0.z += isYZ.z;
	 i0.w += 1.0 - isYZ.z;
	 
	 // i0 now contains the unique values 0,1,2,3 in each channel
	 vec4 i3 = clamp( i0, 0.0, 1.0 );
	 vec4 i2 = clamp( i0-1.0, 0.0, 1.0 );
	 vec4 i1 = clamp( i0-2.0, 0.0, 1.0 );
	 
	 //  x0 = x0 - 0.0 + 0.0 * C.xxxx
	 //  x1 = x0 - i1  + 1.0 * C.xxxx
	 //  x2 = x0 - i2  + 2.0 * C.xxxx
	 //  x3 = x0 - i3  + 3.0 * C.xxxx
	 //  x4 = x0 - 1.0 + 4.0 * C.xxxx
	 vec4 x1 = x0 - i1 + C.xxxx;
	 vec4 x2 = x0 - i2 + C.yyyy;
	 vec4 x3 = x0 - i3 + C.zzzz;
	 vec4 x4 = x0 + C.wwww;
	 
	 // Permutations
	 i = mod289_4(i);
	 float j0 = permute( permute( permute( permute(i.w) + i.z) + i.y) + i.x);
	 vec4 j1 = permute_4( permute_4( permute_4( permute_4 (
					 i.w + vec4(i1.w, i2.w, i3.w, 1.0 ))
					 + i.z + vec4(i1.z, i2.z, i3.z, 1.0 ))
					 + i.y + vec4(i1.y, i2.y, i3.y, 1.0 ))
					 + i.x + vec4(i1.x, i2.x, i3.x, 1.0 ));
	 
	 // Gradients: 7x7x6 points over a cube, mapped onto a 4-cross polytope
	 // 7*7*6 = 294, which is close to the ring size 17*17 = 289.
	 vec4 ip = vec4(1.0/294.0, 1.0/49.0, 1.0/7.0, 0.0) ;
	 
	 vec4 p0 = grad4(j0,   ip);
	 vec4 p1 = grad4(j1.x, ip);
	 vec4 p2 = grad4(j1.y, ip);
	 vec4 p3 = grad4(j1.z, ip);
	 vec4 p4 = grad4(j1.w, ip);
	 
	 // Normalise gradients
	 vec4 norm = taylorInvSqrt_4(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
	 p0 *= norm.x;
	 p1 *= norm.y;
	 p2 *= norm.z;
	 p3 *= norm.w;
	 p4 *= taylorInvSqrt(dot(p4,p4));
	 
	 // Mix contributions from the five corners
	 vec3 m0 = max(0.6 - vec3(dot(x0,x0), dot(x1,x1), dot(x2,x2)), vec3(0.0));
	 vec2 m1 = max(0.6 - vec2(dot(x3,x3), dot(x4,x4)), vec2(0.0));
	 m0 = m0 * m0;
	 m1 = m1 * m1;
	 return 33.0 * (dot(m0*m0, vec3( dot( p0, x0 ), dot( p1, x1 ), dot( p2, x2 )))
					 + dot(m1*m1, vec2( dot( p3, x3 ), dot( p4, x4 ) ) ) ) ;
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex4d.extshader" ****/

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/
/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/

// Description : Array and textureless GLSL 2D/3D/4D simplex 
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
// 

float snoise3d(vec3 v) { 
	 vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
	 vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
	 
	 // First corner
	 vec3 i  = floor(v + dot(v, vec3(C.y)) );
	 vec3 x0 = v - i + dot(i, vec3(C.x)) ;
	 
	 // Other corners
	 vec3 g = step(x0.yzx, x0.xyz);
	 vec3 l = 1.0 - g;
	 vec3 i1 = min( g.xyz, l.zxy );
	 vec3 i2 = max( g.xyz, l.zxy );
	 
	 //   x0 = x0 - 0.0 + 0.0 * C.xxx;
	 //   x1 = x0 - i1  + 1.0 * C.xxx;
	 //   x2 = x0 - i2  + 2.0 * C.xxx;
	 //   x3 = x0 - 1.0 + 3.0 * C.xxx;
	 vec3 x1 = x0 - i1 + vec3(C.x);
	 vec3 x2 = x0 - i2 + vec3(C.y); // 2.0*C.x = 1/3 = C.y
	 vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
	 
	 // Permutations
	 i = mod289_3(i); 
	 vec4 p = permute_4( permute_4( permute_4( 
	 		 i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
	 		+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
	 		+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
	 
	 // Gradients: 7x7 points over a square, mapped onto an octahedron.
	 // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
	 float n_ = 0.142857142857; // 1.0/7.0
	 vec3  ns = n_ * D.wyz - D.xzx;
	 
	 vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
	 
	 vec4 x_ = floor(j * ns.z);
	 vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
	 
	 vec4 x = x_ *ns.x + vec4(ns.y);
	 vec4 y = y_ *ns.x + vec4(ns.y);
	 vec4 h = 1.0 - abs(x) - abs(y);
	 
	 vec4 b0 = vec4( x.xy, y.xy );
	 vec4 b1 = vec4( x.zw, y.zw );
	 
	 //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
	 //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
	 vec4 s0 = floor(b0)*2.0 + 1.0;
	 vec4 s1 = floor(b1)*2.0 + 1.0;
	 vec4 sh = -step(h, vec4(0.0));
	 
	 vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
	 vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
	 
	 vec3 p0 = vec3(a0.xy,h.x);
	 vec3 p1 = vec3(a0.zw,h.y);
	 vec3 p2 = vec3(a1.xy,h.z);
	 vec3 p3 = vec3(a1.zw,h.w);
	 
	 //Normalise gradients
	 vec4 norm = taylorInvSqrt_4(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
	 p0 *= norm.x;
	 p1 *= norm.y;
	 p2 *= norm.z;
	 p3 *= norm.w;
	 
	 // Mix final noise value
	 vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), vec4(0.0));
	 m = m * m;
	 return 22.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );
}

/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/

				void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb *= vec3(snoise3d(vec3(UV * 5.0, TIME)), 
							snoise3d(vec3(UV * 5.0 + vec2(1000.0), TIME)), 
							snoise3d(vec3(UV * 5.0 + vec2(2000.0), TIME)))
		/ 2.0 + 0.5;
}
"""

#var SHADER_TO_TOKENIZE = """/**/
#	/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
#	shader_type canvas_item ;
#	render_mode blend_mix, unshaded, light_only;
#	/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
#
#	/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/
#	/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
#	/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
#
#	/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
#	/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
#	/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
#
#	// Modulo 289 without a division (only multiplications)
#	vec4 mod289_4(vec4 x) {
#		int i = .5;
#		return x - floor(x * (1.0 / 289.0)) * 289.0;
#	}
#	vec4 dummyFunction(vec4 x, float dummy, vec2 dummy2) {
#		int i = .5;
#		return x - floor(x * (1.0 / 289.0)) * 289.0;
#	}
#
#	vec3 mod289_3(vec3 x) {
#		return x - floor(x * (1.0 / 289.0)) * 289.0;
#	}
#
#	vec2 mod289_2(vec2 x) {
#		return x - floor(x * (1.0 / 289.0)) * 289.0;
#	}
#
#	float mod289(float x) {
#		return x - floor(x * (1.0 / 289.0)) * 289.0;
#	}
#
#	// Modulo 7 without a division
#	vec3 mod7_3(vec3 x) {
#		return x - floor(x * (1.0 / 7.0)) * 7.0;
#	}
#
#	vec4 mod7_4(vec4 x) {
#	  return x - floor(x * (1.0 / 7.0)) * 7.0;
#	}
#
#	float permute(float x) {
#		return mod289(((x * 34.0) + 1.0) * x);
#	}
#
#	// Permutation polynomial: (34x^2 + x) mod 289
#	vec3 permute_3(vec3 x) {
#		return mod289_3((34.0 * x + 1.0) * x);
#	}
#
#	// Permutation polynomial: (34x^2 + x) mod 289
#	vec4 permute_4(vec4 x) {
#	  return mod289_4((34.0 * x + 1.0) * x);
#	}
#
#	vec4 taylorInvSqrt_4(vec4 r) {
#		return 1.79284291400159 - 0.85373472095314 * r;
#	}
#
#	float taylorInvSqrt(float r) {
#		return 2.79284291400159 - 1.85373472095314 * r;
#	}
#
#	vec2 fade_2(vec2 t) {
#		return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
#	}
#
#	vec3 fade_3(vec3 t) {
#		return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
#	}
#
#	vec4 fade_4(vec4 t) {
#		return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
#	}
#
#	/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
#
#	// Description : Array and textureless GLSL 2D/3D/4D simplex 
#	//               noise functions.
#	//      Author : Ian McEwan, Ashima Arts.
#	//  Maintainer : stegu
#	//     Lastmod : 20110822 (ijm)
#	//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
#	//               Distributed under the MIT License. See LICENSE file.
#	//               https://github.com/ashima/webgl-noise
#	//               https://github.com/stegu/webgl-noise
#	// 
#
#	float snoise3d(vec3 v) { 
#		vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
#		vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
#
#		// First corner
#		vec3 i  = floor(v + dot(v, vec3(C.y)) );
#		vec3 x0 = v - i + dot(i, vec3(C.x)) ;
#
#		// Other corners
#		vec3 g = step(x0.yzx, x0.xyz);
#		vec3 l = 1.0 - g;
#		vec3 i1 = min( g.xyz, l.zxy );
#		vec3 i2 = max( g.xyz, l.zxy );
#
#		//   x0 = x0 - 0.0 + 0.0 * C.xxx;
#		//   x1 = x0 - i1  + 1.0 * C.xxx;
#		//   x2 = x0 - i2  + 2.0 * C.xxx;
#		//   x3 = x0 - 1.0 + 3.0 * C.xxx;
#		vec3 x1 = x0 - i1 + vec3(C.x);
#		vec3 x2 = x0 - i2 + vec3(C.y); // 2.0*C.x = 1/3 = C.y
#		vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
#
#		// Permutations
#		i = mod289_3(i); 
#		vec4 p = permute_4( permute_4( permute_4( 
#				 i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
#				+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
#				+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
#
#		// Gradients: 7x7 points over a square, mapped onto an octahedron.
#		// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
#		float n_ = 0.142857142857; // 1.0/7.0
#		vec3  ns = n_ * D.wyz - D.xzx;
#
#		vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
#
#		vec4 x_ = floor(j * ns.z);
#		vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
#
#		vec4 x = x_ *ns.x + vec4(ns.y);
#		vec4 y = y_ *ns.x + vec4(ns.y);
#		vec4 h = 1.0 - abs(x) - abs(y);
#
#		vec4 b0 = vec4( x.xy, y.xy );
#		vec4 b1 = vec4( x.zw, y.zw );
#
#		//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
#		//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
#		vec4 s0 = floor(b0)*2.0 + 1.0;
#		vec4 s1 = floor(b1)*2.0 + 1.0;
#		vec4 sh = -step(h, vec4(0.0));
#
#		vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
#		vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
#
#		vec3 p0 = vec3(a0.xy,h.x);
#		vec3 p1 = vec3(a0.zw,h.y);
#		vec3 p2 = vec3(a1.xy,h.z);
#		vec3 p3 = vec3(a1.zw,h.w);
#
#		//Normalise gradients
#		vec4 norm = taylorInvSqrt_4(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
#		p0 *= norm.x;
#		p1 *= norm.y;
#		p2 *= norm.z;
#		p3 *= norm.w;
#
#		// Mix final noise value
#		vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), vec4(0.0));
#		m = m * m;
#		return 22.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );
#	}
#
#	/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/
#
#	uniform vec3 pos = vec3(0.0);
#
#	void fragment() {
#		COLOR = texture(TEXTURE, UV);
#		COLOR.rgb *= vec3(snoise3d(vec3(UV * 5.0, TIME)), 
#						  snoise3d(vec3(UV * 5.0 + vec2(1000.0), TIME)), 
#						  snoise3d(vec3(UV * 5.0 + vec2(2000.0), TIME)))
#			/ 2.0 + 0.5;
#		// switch
#		switch(i) { // signed integer expression
#			 case -1:
#				  break;
#			 case 0:
#				  return; // break or return
#			 case 1: // pass-through
#			 case 2:
#				  break;
#			 //...
#			 default: // optional
#				  break;
#		}
#
#	}
#	"""

var bench_progress: ProgressBar

const GslTokens = preload("res://Tokens.gd")
const GslTokenizer = preload("res://gsl_tokenizer.gd")
const GslParser = preload("res://gsl_parser.gd")

var tokenizer: GslTokenizer = GslTokenizer.new()
var parser : GslParser = GslParser.new()

var tokenized_text := ""
var parsed_text: String = ""

func highlight_token_tree():
	clear_colors()
	add_color_region("'", "'", symbol_color)
	add_color_region("\"", "\"", quote_color)
	add_keyword_color("True", bool_color)
	add_keyword_color("False", bool_color)
	add_keyword_color("KeywordToken", keyword_token_color)
	add_keyword_color("KeywordValueToken", keyword_value_token_color)
	add_keyword_color("TypeToken", type_token_color)
	add_keyword_color("TypeModifierToken", type_modifier_token_color)
	add_keyword_color("EditorHintToken", editor_hint_token_color)
	add_keyword_color("IdentifierToken", identifier_token_color)
	add_keyword_color("NumberToken", number_token_color)
	add_keyword_color("SemicolonToken", semicolon_token_color)
	add_keyword_color("ColonToken", colon_token_color)
	add_keyword_color("CommaToken", comma_token_color)
	add_keyword_color("WhitespaceToken", whitespace_token_color)
	add_keyword_color("DelimToken", delim_token_color)
	add_keyword_color("OperatorToken", op_token_color)

var parse_box: TextEdit

func highlight_parse_tree():
	parse_box.clear_colors()
	parse_box.add_keyword_color("shader_type", keyword_token_color)
	parse_box.add_keyword_color("render_mode", keyword_token_color)
	parse_box.add_keyword_color("function_table", keyword_token_color)
	parse_box.add_keyword_color("var_table", keyword_token_color)
	parse_box.add_keyword_color("Key", keyword_value_token_color)
	parse_box.add_keyword_color("Value", keyword_value_token_color)
	parse_box.add_keyword_color("arguments", bool_color)
	parse_box.add_keyword_color("return", delim_token_color)
	parse_box.add_keyword_color("name", type_modifier_token_color)
	parse_box.add_keyword_color("type", quote_color)

func _ready() -> void:
	highlight_token_tree()
	# Tests the tokenizer
	yield(get_tree(), "idle_frame")
	bench_progress = $"../../Tools/BenchProgress"
	bench_progress.max_value = bench_count
	$"../../Tools/BenchCount".value = bench_count
	parse_box = $"../TextEdit2"
	highlight_parse_tree()
	visible = not $"../../Tools/CheckButton".pressed
	parse_box.visible = $"../../Tools/CheckButton".pressed
	do_token_and_parse()

var thread: Thread

func _on_Benchmark_pressed() -> void:
	if not thread:
		thread = Thread.new()
	if thread.is_active():
		bench_mutex.lock()
		bench_continue = false
		bench_mutex.unlock()
		thread.wait_to_finish()
		thread = Thread.new()
	bench_progress.max_value = bench_count
	if thread.start(self, "do_benchmark"):
		printerr("failed to start benchmark")

var bench_count = 1000

var bench_continue: bool = true
var bench_mutex: Mutex = Mutex.new()

func do_benchmark(_data) -> void:
	bench_mutex.lock()
	var BENCH_COUNT = bench_count
	bench_continue = true
	bench_mutex.unlock()
	var total_time := 0
	var max_time: int = -100000000000000
	var min_time: int = 1000000000000000000
	
	for i in range(0, BENCH_COUNT):
		var time = OS.get_ticks_usec()
		var tokenized := tokenizer.tokenize(SHADER_TO_TOKENIZE)
		var _parsed = parser.parse(tokenized)
		var elapsed_micros = OS.get_ticks_usec() - time
		total_time += elapsed_micros
		if min_time > elapsed_micros:
			min_time = elapsed_micros
		if max_time < elapsed_micros:
			max_time = elapsed_micros
		bench_mutex.lock()
		if not bench_continue:
			bench_mutex.unlock()
			return
		bench_mutex.unlock()
		bench_progress.call_deferred("set_value", i + 1)
	
	var average = ((total_time as float) / (BENCH_COUNT as float)) / 1000000.0
	self.call_deferred("display_bench_results", average, (min_time as float) / 1000000.0, (max_time as float) / 1000000.0)

func display_bench_results(average: float, min_time: float, max_time: float) -> void:
	print("Displaying results")
	$Results.dialog_text = """Completed %d iterations
Took %f Seconds on average
(Approximately %f frames at 60 fps)
(max %fs, min %fs)""" % [bench_count, average, average / (1.0/60.0), max_time, min_time]
	$Results.show()


func _exit_tree() -> void:
	if thread:
		bench_mutex.lock()
		bench_continue = false
		bench_mutex.unlock()
		thread.wait_to_finish()


func _on_Results_confirmed() -> void:
	bench_progress.set_value(0)


func _on_BenchCount_value_changed(value: float) -> void:
	bench_mutex.lock()
	bench_count = value
	if not thread or not thread.is_active():
		bench_progress.max_value = bench_count
	bench_mutex.unlock()


func _on_ParsedButton_toggled(button_pressed: bool) -> void:
	visible = not button_pressed
	parse_box.visible = button_pressed


func _on_ChangeShaderButton_pressed() -> void:
	$"../../../NSPHolder/NewShaderPopup".popup_centered()

func do_token_and_parse() -> void:
	
	print("Preparing to tokenize...")
	var time = OS.get_ticks_usec()
	var tokenized := tokenizer.tokenize(SHADER_TO_TOKENIZE)
	var elapsed_micros = OS.get_ticks_usec() - time
	print("Tokenized in %f seconds. Displaying..." % ((elapsed_micros as float) / 1000000.0))
	time = OS.get_ticks_usec()
	var temp_text := ""
	var first_token = true
	for token in tokenized:
		if not first_token:
			if (token as GslTokens.Token).TYPE == GslTokens.TokenType.WHITESPACE:
				# Whitespace tokens should only exist to consume leading whitespace in the file
				printerr("Non-first Whitespace Token detected!")
		else:
			first_token = false
		temp_text += token.to_string() + "\n"
	tokenized_text = temp_text
	text = tokenized_text
	elapsed_micros = OS.get_ticks_usec() - time
	print("Displayed in %f seconds." % ((elapsed_micros as float) / 1000000.0))
	var parsed := parser.parse(tokenized)
	parsed_text = ""
	if parsed.has("error"):
		var pos = parsed.pos
		var eline = tokenized[pos].line
		parsed_text += "Error occured while parsing!\nOn line: " + String(tokenized[pos].line)
		var startofline = pos
		while tokenized[startofline - 1].line == eline:
			startofline -= 1
		var plinetokenws: String = tokenized[startofline - 1].whitespace
		var column := plinetokenws.substr(plinetokenws.rfind("\n") + 1).length()
		for tpos in range(startofline, pos):
			column += tokenized[tpos].get_length()
		parsed_text += "\nColumn: " + String(column)
		parsed_text += "\nError: " + parsed.error
	else:
		for key in parsed.keys():
			var pblock: String = key + ": "
			if typeof(parsed[key]) == TYPE_DICTIONARY:
				var parse_branch: Dictionary = parsed[key]
				pblock += "\n"
				for bkey in parse_branch:
					var pline: String = "\tKey: " + bkey + ","
					var ln = pline.length()
					while ln < 30:
						ln += 1
						pline += " "
					pline += "Value: " + String(parse_branch[bkey]) + "\n"
					pblock += pline
			else:
				pblock += String(parsed[key]) + "\n"
			parsed_text += pblock
	parse_box.text = parsed_text

func _on_NewShaderPopup_confirmed() -> void:
	SHADER_TO_TOKENIZE = $"../../../NSPHolder/NewShaderPopup/TextEdit".text
	do_token_and_parse()
