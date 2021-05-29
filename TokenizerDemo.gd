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

const SHADER_TO_TOKENIZE = """    
		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
		shader_type canvas_item ;
		render_mode blend_mix, unshaded, light_only;
		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/simplex3d.extshader" ****/
		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/noise/mathlib.extshader" ****/
		/**** INCLUDED FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/
		/**** END OF INCLUDE FROM  "res://addons/sisilicon.shaders.extended-shader/builtin_shaders/canvas_hedr.extshader" ****/

		// Modulo 289 without a division (only multiplications)
		vec4 mod289_4(vec4 x) {
			int i = .5;
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

		uniform vec3 pos = vec3(0.0);
		
		void fragment() {
			COLOR = texture(TEXTURE, UV);
			COLOR.rgb *= vec3(snoise3d(vec3(UV * 5.0, TIME)), 
							  snoise3d(vec3(UV * 5.0 + vec2(1000.0), TIME)), 
							  snoise3d(vec3(UV * 5.0 + vec2(2000.0), TIME)))
				/ 2.0 + 0.5;
			// switch
			switch(i) { // signed integer expression
				 case -1:
					  break;
				 case 0:
					  return; // break or return
				 case 1: // pass-through
				 case 2:
					  break;
				 //...
				 default: // optional
					  break;
			}

		}
	"""

var bench_progress: ProgressBar

const GslTokens = preload("res://Tokens.gd")
const GslTokenizer = preload("res://gsl_tokenizer.gd")
const GslParser = preload("res://gsl_parser.gd")

var tokenizer: GslTokenizer = GslTokenizer.new()
var parser : GslParser = GslParser.new()

func _ready() -> void:
	if true: # Add color regions
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
		add_keyword_color("GslTokens.OperatorToken", op_token_color)
	if true: # Tests the tokenizer
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
		text = temp_text
		elapsed_micros = OS.get_ticks_usec() - time
		print("Displayed in %f seconds." % ((elapsed_micros as float) / 1000000.0))
		print(parser.parse(tokenized))
		yield(get_tree(), "idle_frame")
		bench_progress = $"../Tools/BenchProgress"
		bench_progress.max_value = bench_count
		$"../Tools/BenchCount".value = bench_count


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
		var _tokenized := tokenizer.tokenize(SHADER_TO_TOKENIZE)
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
	$Results.dialog_text = "Completed %d iterations\nTook %f Seconds on average\n(max %fs, min %fs)" % [bench_count, average, max_time, min_time]
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
