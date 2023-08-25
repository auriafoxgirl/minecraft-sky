#version 120

#include "sky.glsl"

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 glcolor;

varying float vertexDistance;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;

	// fog
	float fragmentDistance = vertexDistance;
	float fogFactor;
	float x = fragmentDistance;
	fogFactor = exp(-x * x);
	fogFactor = clamp(fogFactor, 0.0, 1.0);

	// blend clouds color and sky
	color.rgb = mix(getFinalSky(), mix(getClouds(), color.rgb, 0.25), fogFactor);

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}