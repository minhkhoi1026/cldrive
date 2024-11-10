
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}




#define RISKFREE 0.02f
#define VOLATILITY 0.30f

__kernel
void 
binomial_options(
    int numSteps,
    const __global float4* randArray,
    __global float4* output,
    __local float4* callA,
    __local float4* callB)
{
    
    unsigned int tid = get_local_id(0);
    unsigned int bid = get_group_id(0);

    float4 inRand = randArray[hook(1, bid)];

    float4 s = (1.0f - inRand) * 5.0f + inRand * 30.f;
    float4 x = (1.0f - inRand) * 1.0f + inRand * 100.f;
    float4 optionYears = (1.0f - inRand) * 0.25f + inRand * 10.f; 
    float4 dt = optionYears * (1.0f / (float)numSteps);
    float4 vsdt = VOLATILITY * sqrt(dt);
    float4 rdt = RISKFREE * dt;
    float4 r = exp(rdt);
    float4 rInv = 1.0f / r;
    float4 u = exp(vsdt);
    float4 d = 1.0f / u;
    float4 pu = (r - d)/(u - d);
    float4 pd = 1.0f - pu;
    float4 puByr = pu * rInv;
    float4 pdByr = pd * rInv;

    float4 profit = s * exp(vsdt * (2.0f * tid - (float)numSteps)) - x;
    callA[hook(3, tid)].x = profit.x > 0 ? profit.x : 0.0f;
    callA[hook(3, tid)].y = profit.y > 0 ? profit.y : 0.0f;
    callA[hook(3, tid)].z = profit.z > 0 ? profit.z: 0.0f;
    callA[hook(3, tid)].w = profit.w > 0 ? profit.w: 0.0f;

    barrier(CLK_LOCAL_MEM_FENCE);

    for(int j = numSteps; j > 0; j -= 2)
    {
        if(tid < j)
        {
            callB[hook(4, tid)] = puByr * callA[hook(3, tid)] + pdByr * callA[hook(3, tid + 1)];
        }
        barrier(CLK_LOCAL_MEM_FENCE);

        if(tid < j - 1)
        {
            callA[hook(3, tid)] = puByr * callB[hook(4, tid)] + pdByr * callB[hook(4, tid + 1)];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    if(tid == 0) output[hook(2, bid)] = callA[hook(3, 0)];
}