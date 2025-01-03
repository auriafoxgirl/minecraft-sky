#define SKY_COLOR 0 // color of sky [0 1 2 3]

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
#if SKY_COLOR == 4
   vec3 getSky() {
      vec3 normal = getNormal();
      return mix(vec3(0.949, 0.937, 0.941), vec3(0.239, 0.239, 0.239));
   }
   vec3 getClouds() { return vec3(1.0); }
#elif SKY_COLOR == 3
   vec3 getSky() {
      vec3 normal = getNormal();
      float t = clamp(normal.x + 0.5, 0.0, 1.0);
      float k = clamp(normal.y + 0.5, 0.0, 1.0) * 0.4;
      return mix(mix(vec3(0.71, 0.2, 0.49), vec3(0.89, 0.35, 0.18), t), vec3(1.0), k);
   }
   vec3 getClouds() {
      vec3 normal = getNormal();
      return mix(vec3(1.0, 0.7, 0.87), vec3(1.0, 0.73, 0.55), clamp(normal.x + 0.5, 0.0, 1.0));
   }
   // vec3 getClouds() { return vec3(1.0); }
#elif SKY_COLOR == 2
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
