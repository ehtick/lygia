#include "map.hlsl"

/*
contributors:  Inigo Quiles
description: Calculate normals http://iquilezles.org/www/articles/normalsSDF/normalsSDF.htm
use: <float> raymarchNormal( in <float3> pos ) 
*/

#ifndef RAYMARCH_MAP_FNC
#define RAYMARCH_MAP_FNC(POS) raymarchMap(POS)
#endif

#ifndef RAYMARCH_MAP_DISTANCE
#define RAYMARCH_MAP_DISTANCE a
#endif

#ifndef FNC_RAYMARCHNORMAL
#define FNC_RAYMARCHNORMAL

float3 raymarchNormal(float3 pos, float2 pixel) {
   float2 offset = float2(1.0, -1.0) * pixel;
   return normalize( offset.xyy * RAYMARCH_MAP_FNC(pos + offset.xyy).sdf +
                     offset.yyx * RAYMARCH_MAP_FNC(pos + offset.yyx).sdf +
                     offset.yxy * RAYMARCH_MAP_FNC(pos + offset.yxy).sdf +
                     offset.xxx * RAYMARCH_MAP_FNC(pos + offset.xxx).sdf);
}

float3 raymarchNormal(float3 pos, float e) {
   const float2 offset = float2(1.0, -1.0) * e;
    return normalize(offset.xyy * RAYMARCH_MAP_FNC(pos + offset.xyy).sdf +
                     offset.yyx * RAYMARCH_MAP_FNC(pos + offset.yyx).sdf +
                     offset.yxy * RAYMARCH_MAP_FNC(pos + offset.yxy).sdf +
                     offset.xxx * RAYMARCH_MAP_FNC(pos + offset.xxx).sdf);
}

float3 raymarchNormal( in float3 pos ) {
   return raymarchNormal(pos, 0.5773 * 0.0005);
}

#endif