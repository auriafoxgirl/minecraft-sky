#version 120

#include "sky.glsl"

varying vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.

void main() {
	vec3 color;
	if (starData.a > 0.5) {
		color = starData.rgb;
	} else {
		color = getFinalSky();
		// vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		// pos = gbufferProjectionInverse * pos;
		// vec3 normal = (gbufferModelViewInverse * pos).rgb;
		// color = normalize(normal) * 0.5 + 0.5;

		// color *= 0.5;
		// color += 0.5;
		// color *= 0.2 + min((skyColor.r + skyColor.g + skyColor.b) / 2.0, 0.8);
	}


	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0);
}