

#define maxSteps 500
#define tstep 0.01f




int intersectBox(float4 r_o, float4 r_d, float4 boxmin, float4 boxmax, float *tnear, float *tfar)
{
    
    float4 invR = (float4)(1.0f,1.0f,1.0f,1.0f) / r_d;
    float4 tbot = invR * (boxmin - r_o);
    float4 ttop = invR * (boxmax - r_o);

    
    float4 tmin = min(ttop, tbot);
    float4 tmax = max(ttop, tbot);

    
    float largest_tmin = max(max(tmin.x, tmin.y), max(tmin.x, tmin.z));
    float smallest_tmax = min(min(tmax.x, tmax.y), min(tmax.x, tmax.z));

	*tnear = largest_tmin;
	*tfar = smallest_tmax;

	return smallest_tmax > largest_tmin;
}

uint rgbaFloatToInt(float4 rgba)
{
    rgba.x = clamp(rgba.x,0.0f,1.0f);  
    rgba.y = clamp(rgba.y,0.0f,1.0f);  
    rgba.z = clamp(rgba.z,0.0f,1.0f);  
    rgba.w = clamp(rgba.w,0.0f,1.0f);  
    return ((uint)(rgba.w*255.0f)<<24) | ((uint)(rgba.z*255.0f)<<16) | ((uint)(rgba.y*255.0f)<<8) | (uint)(rgba.x*255.0f);
}

__kernel void
d_render(__global uint *d_output, 
         uint imageW, uint imageH,
         float density, float brightness,
         float transferOffset, float transferScale,
         __constant float* invViewMatrix
 #ifdef IMAGE_SUPPORT
          ,__read_only image3d_t volume,
          __read_only image2d_t transferFunc,
          sampler_t volumeSampler,
          sampler_t transferFuncSampler
 #endif
         )

{	
    uint x = get_global_id(0);
    uint y = get_global_id(1);

    float u = (x / (float) imageW)*2.0f-1.0f;
    float v = (y / (float) imageH)*2.0f-1.0f;

    
    float4 boxMin = (float4)(-1.0f, -1.0f, -1.0f,1.0f);
    float4 boxMax = (float4)(1.0f, 1.0f, 1.0f,1.0f);

    
    float4 eyeRay_o;
    float4 eyeRay_d;

    eyeRay_o = (float4)(invViewMatrix[3], invViewMatrix[7], invViewMatrix[11], 1.0f);   

    float4 temp = normalize(((float4)(u, v, -2.0f,0.0f)));
    eyeRay_d.x = dot(temp, ((float4)(invViewMatrix[0],invViewMatrix[1],invViewMatrix[2],invViewMatrix[3])));
    eyeRay_d.y = dot(temp, ((float4)(invViewMatrix[4],invViewMatrix[5],invViewMatrix[6],invViewMatrix[7])));
    eyeRay_d.z = dot(temp, ((float4)(invViewMatrix[8],invViewMatrix[9],invViewMatrix[10],invViewMatrix[11])));
    eyeRay_d.w = 0.0f;

    
	float tnear, tfar;
	int hit = intersectBox(eyeRay_o, eyeRay_d, boxMin, boxMax, &tnear, &tfar);
    if (!hit) {
        if ((x < imageW) && (y < imageH)) {
            
            uint i =(y * imageW) + x;
            d_output[i] = 0;
        }
        return;
    }
	if (tnear < 0.0f) tnear = 0.0f;     

    
    temp = (float4)(0.0f,0.0f,0.0f,0.0f);
    float t = tfar;

    for(uint i=0; i<maxSteps; i++) {		
        float4 pos = eyeRay_o + eyeRay_d*t;
        pos = pos*0.5f+0.5f;    

        
#ifdef IMAGE_SUPPORT        
        float4 sample = read_imagef(volume, volumeSampler, pos);
        
        
        float2 transfer_pos = (float2)((sample.x-transferOffset)*transferScale, 0.5f);
        float4 col = read_imagef(transferFunc, transferFuncSampler, transfer_pos);
#else
        float4 col = (float4)(pos.x,pos.y,pos.z,.25f);
#endif


        
        float a = col.w*density;
        temp = mix(temp, col, (float4)(a, a, a, a));

        t -= tstep;
        if (t < tnear) break;
    }
    temp *= brightness;

    if ((x < imageW) && (y < imageH)) {
        
        uint i =(y * imageW) + x;
        d_output[i] = rgbaFloatToInt(temp);
    }
}

