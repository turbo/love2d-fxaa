// ----------------------------- VERTEX ----------------------------------------

#ifdef VERTEX

vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}

#endif

// ----------------------------- FRAGMENT -------------------------------------
 
#ifdef PIXEL

uniform float sharpness;

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  vec2 res = love_ScreenSize.xy;
  vec2 fragCoord = texture_coords * res; 

  vec2 uv = fragCoord.xy / res.xy;
    
  vec2 step = 1.0 / res.xy;
  
  vec3 texA = Texel(tex, uv + vec2(-step.x, -step.y) * 1.5 ).rgb;
  vec3 texB = Texel(tex, uv + vec2( step.x, -step.y) * 1.5 ).rgb;
  vec3 texC = Texel(tex, uv + vec2(-step.x,  step.y) * 1.5 ).rgb;
  vec3 texD = Texel(tex, uv + vec2( step.x,  step.y) * 1.5 ).rgb; 
  vec3 around = 0.25 * (texA + texB + texC + texD);
  vec3 center  = Texel(tex, uv).rgb;
  
  // float sharpness = 0.4;
    
  vec3 col = center + (center - around) * sharpness;
  
  return vec4(col,1.0);
}

#endif
