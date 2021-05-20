# Extended-Shader-Plugin

Hello! This is demo(?) Plugin for adding preprocessors to shaders in Godot 3.1
It currently supports the following directives.
* #define (There's a bug where nesting brackets inside a function macro can't work.)
* #undef
* #ifdef
* #ifndef
* #if
* #elif
* #else
* #endif
* #include

You need to enable the plugin in the `Project Settings` first and close and open the project before you can use it.

## Making an extended shader

To make an extended shader create a new resource via the inspector or the file system. Search for `Extended Shader` and create it. Note that while Godot defaults to suggesting the `.shader` file extension, this will cause import errors when the project is saved and reloaded, as Godot will mistake it for a normal shader. The plugin will attempt to automatically remap improperly saved ExtendedShaders, but this may rarely break scene dependencies.

## include preprocessors

`#include` can be used to add code from shader fragments. These fragments must be extended shader as well. A common practice when using preprocessor directives is to guard your shader fragments in a `#ifndef` as seen the demo. This way you can include them multiple times without duplicating code. `#includes` can be nested too.
To include a shader, use `#include "shader_name"` - if no file extension is provided, the plugin will automatically assume `.extshader`.

There are also a set of 'built-in' small library shaders, which provide a redefinition-avoiding `shader_type` header -- intended to allow further library shaders to be created and edited without constant "expected `shader_type` at beginning of shader" errors. To use them, use `#include <"builtin_name">`.

The current provided set of builtin library shaders is:
* canvas_hedr
* particles_hedr
* spatial_hedr

## variable macros

The extended shader has a `defines` dictionary that allows you to prepend macros to the shader. The keys __must__ be a string. 

## The editor

The editor is still rough, and might break. If the editor begins misbehaving, *copy your shader text out of the file*, then restart the editor (sometimes the shader file will become broken when the editor breaks, at which point you need to recreate it using the copied source code -- it's currently unknown if this bug only occurs when live-editing the editor script files). Also note that if you use `#if`, `#ifdef` or `#ifndef` statements, code that gets omitted by them will not be accounted for, and so it's a good idea to test each branch for errors.

## One more thing

This project is more of a proof of concept. While it _could_ be used in production, only light testing has been done in exported projects, and I can't guarantee it will be very stable. I'm using it for my projects, so I'll probably be idly maintaining it until Godot gets shader preprocessing built-in. I also will take pull requests.


## External Assets

This project makes use of a modified copy of the shaders provided by curly-brace's [Noise Shaders repository](https://github.com/curly-brace/Godot-3.0-Noise-Shaders/).

This project also uses the [Hack font](https://github.com/source-foundry/Hack/), and an icon from [the Godot Engine](https://github.com/godotengine/godot).
