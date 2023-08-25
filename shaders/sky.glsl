#define SKY_COLOR 0 // color of sky [0 1 2]

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform vec3 skyColor;

vec3 getNormal() {
   vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
	pos = gbufferProjectionInverse * pos;
   return normalize((gbufferModelViewInverse * pos).rgb);
}

#if SKY_COLOR == 2
   vec3 getSky() {
      vec3 normal = getNormal();
      return mix(vec3(0.49, 0.95, 1.0), vec3(1.0, 0.73, 0.81), clamp(normal.y + 0.5, 0.0, 1.0));
   }
   vec3 getClouds() { return vec3(1.0); }
#elif SKY_COLOR == 1
   vec3 getSky() { return (1.0 - getNormal()) * 0.25 + 0.75; }
   vec3 getClouds() { return (1.0 - getNormal()) * 0.5 + 0.5; }
#else
   vec3 getSky() { return getNormal() * 0.25 + 0.75; }
   vec3 getClouds() { return getNormal() * 0.5 + 0.5; }
#endif

vec3 getFinalSky() {
   vec3 color = getSky();
   color *= 0.25 + min((skyColor.r + skyColor.g + skyColor.b) / 2.0, 0.75);
   return color;
}