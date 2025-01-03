#define SKY_COLOR 0 // color of sky [0 1 2 3 4]

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

#if SKY_COLOR == 4 // bi
   vec3 getSky() {
      vec3 normal = getNormal();
      float t = clamp(normal.x * 0.5 + 0.5, 0.0, 1.0);
      float k = clamp(normal.y + 0.5, 0.0, 1.0) * 0.1;
      return mix(
         mix(vec3(0.84, 0.01, 0.44), vec3(0.0, 0.22, 0.66), t),
         vec3(1.0),
         k
      );
   }
   vec3 getClouds() {
      vec3 normal = getNormal();
      float t = clamp(normal.x * 0.5 + 0.5, 0.0, 1.0);
      return mix(vec3(0.71, 0.6, 0.68), vec3(0.61, 0.31, 0.59), t);
   }
#elif SKY_COLOR == 3 // lesbian
   vec3 getSky() {
      vec3 normal = getNormal();
      float t = clamp(normal.x + 0.5, 0.0, 1.0);
      float k = clamp(normal.y + 0.5, 0.0, 1.0) * 0.4;
      return mix(
         mix(vec3(0.71, 0.2, 0.49), vec3(0.89, 0.35, 0.18), t),
         vec3(1.0),
         k
      );
   }
   vec3 getClouds() {
      vec3 normal = getNormal();
      return mix(vec3(1.0, 0.7, 0.87), vec3(1.0, 0.73, 0.55), clamp(normal.x + 0.5, 0.0, 1.0));
   }
#elif SKY_COLOR == 2 // trans
   vec3 getSky() {
      vec3 normal = getNormal();
      return mix(vec3(0.49, 0.95, 1.0), vec3(1.0, 0.73, 0.81), clamp(normal.y + 0.5, 0.0, 1.0));
   }
   vec3 getClouds() { return vec3(1.0); }
#elif SKY_COLOR == 1 // gay alt
   vec3 getSky() { return (1.0 - getNormal()) * 0.25 + 0.75; }
   vec3 getClouds() { return (1.0 - getNormal()) * 0.5 + 0.5; }
#else // gay
   vec3 getSky() { return getNormal() * 0.25 + 0.75; }
   vec3 getClouds() { return getNormal() * 0.5 + 0.5; }
#endif

vec3 getFinalSky() {
   vec3 color = getSky();
   color *= 0.25 + min((skyColor.r + skyColor.g + skyColor.b) / 2.0, 0.75);
   return color;
}