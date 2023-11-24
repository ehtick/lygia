#include "envMap.glsl"
#include "ior.glsl"
#include "ior/2eta.glsl"
#include "ior/2f0.glsl"

/*
contributors: Patricio Gonzalez Vivo
description: 
use:
    - <vec3> transparent(<vec3> normal, <vec3> view, <vec3> ior, <float> roughness)
*/

#if !defined(TRANSPARENT_DISPERSION) && defined(TRANSPARENT_DISPERSION_PASSES)
#define TRANSPARENT_DISPERSION 0.05
#elif defined(TRANSPARENT_DISPERSION) && !defined(TRANSPARENT_DISPERSION_PASSES)
#define TRANSPARENT_DISPERSION_PASSES 6
#endif

#ifndef FNC_TRANSPARENT
#define FNC_TRANSPARENT

vec3 transparent(vec3 normal, vec3 view, vec3 eta, vec3 f0, float roughness) {
    vec3 color  = vec3(0.0);
    vec3 T      = max(vec3(0.0), 1.0-fresnel(f0, -dot(view, normal)));

    #if defined(TRANSPARENT_DISPERSION) && defined(TRANSPARENT_DISPERSION_PASSES)
        float pass_step = 1.0/float(TRANSPARENT_DISPERSION_PASSES);
        vec3 bck = vec3(0.0);
        for ( int i = 0; i < TRANSPARENT_DISPERSION_PASSES; i++ ) {
            float slide = float(i) * pass_step * TRANSPARENT_DISPERSION;
            vec3 R      = refract(view, normal, eta.g );
            vec3 ref    = envMap(R, roughness, 0.0);

            #if !defined(TRANSPARENT_DISPERSION_FAST) && !defined(TARGET_MOBILE) && !defined(PLATFORM_RPI)
            ref.r       = envMap(refract(view, normal, eta.r - slide), roughness, 0.0).r;
            ref.b       = envMap(refract(view, normal, eta.b + slide), roughness, 0.0).b;
            #endif

            bck += ref;
        }
        color.rgb   = bck * pass_step;
    #else 

        vec3 R      = refract(view, normal, eta.g);
        color       = envMap(R, roughness);

        #if !defined(TRANSPARENT_DISPERSION_FAST) && !defined(TARGET_MOBILE) && !defined(PLATFORM_RPI)
        vec3 RaR    = refract(view, normal, eta.r);
        vec3 RaB    = refract(view, normal, eta.b);
        color.r     = envMap(RaR, roughness).r;
        color.b     = envMap(RaB, roughness).b;
        #endif

    #endif

    return color*T*T*T*T;
}

vec3 transparent(vec3 normal, vec3 view, vec3 eta, float f0, float roughness) {
    vec3 color  = vec3(0.0);
    float T     = max(0.0, 1.0-fresnel(f0, -dot(view, normal)));

    #if defined(TRANSPARENT_DISPERSION) && defined(TRANSPARENT_DISPERSION_PASSES)
        float pass_step = 1.0/float(TRANSPARENT_DISPERSION_PASSES);
        vec3 bck = vec3(0.0);
        for ( int i = 0; i < TRANSPARENT_DISPERSION_PASSES; i++ ) {
            float slide = float(i) * pass_step * TRANSPARENT_DISPERSION;
            vec3 R      = refract(view, normal, eta.g );
            vec3 ref    = envMap(R, roughness, 0.0);

            #if !defined(TRANSPARENT_DISPERSION_FAST) && !defined(TARGET_MOBILE) && !defined(PLATFORM_RPI)
            ref.r       = envMap(refract(view, normal, eta.r - slide), roughness, 0.0).r;
            ref.b       = envMap(refract(view, normal, eta.b + slide), roughness, 0.0).b;
            #endif

            bck += ref;
        }
        color.rgb   = bck * pass_step;
    #else 

        vec3 R      = refract(view, normal, eta.g);
        color       = envMap(R, roughness);

        #if !defined(TRANSPARENT_DISPERSION_FAST) && !defined(TARGET_MOBILE) && !defined(PLATFORM_RPI)
        vec3 RaR    = refract(view, normal, eta.r);
        vec3 RaB    = refract(view, normal, eta.b);
        color.r     = envMap(RaR, roughness).r;
        color.b     = envMap(RaB, roughness).b;
        #endif

    #endif

    return color*T*T*T*T;
}

#endif
