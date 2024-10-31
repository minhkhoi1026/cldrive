

#if(0)
    #define EXP(a) native_exp(a)
    #define LOG(a) native_log(a)
    #define SQRT(a) native_sqrt(a)
#else
    #define EXP(a) exp(a)
    #define LOG(a) log(a)
    #define SQRT(a) sqrt(a)
#endif





float CND(float d);
void BlackScholesBody(__global float *call, __global float *put,  float S,
					  float X, float T, float R, float V);




float CND(float d){
    const float       A1 = 0.31938153f;
    const float       A2 = -0.356563782f;
    const float       A3 = 1.781477937f;
    const float       A4 = -1.821255978f;
    const float       A5 = 1.330274429f;
    const float RSQRT2PI = 0.39894228040143267793994605993438f;

    float
        K = 1.0f / (1.0f + 0.2316419f * fabs(d));

    float
        cnd = RSQRT2PI * EXP(- 0.5f * d * d) * 
        (K * (A1 + K * (A2 + K * (A3 + K * (A4 + K * A5)))));

    if(d > 0)
        cnd = 1.0f - cnd;

    return cnd;
}





void BlackScholesBody(
    __global float *call, 
    __global float *put,  
    float S,              
    float X,              
    float T,              
    float R,              
    float V               
){
    float sqrtT = SQRT(T);
    float    d1 = (LOG(S / X) + (R + 0.5f * V * V) * T) / (V * sqrtT);
    float    d2 = d1 - V * sqrtT;
    float CNDD1 = CND(d1);
    float CNDD2 = CND(d2);

    
    float expRT = EXP(- R * T);
    *call = (S * CNDD1 - X * expRT * CNDD2);
    *put  = (X * expRT * (1.0f - CNDD2) - S * (1.0f - CNDD1));
}



__kernel void BlackScholes(
    __global float *d_Call, 
    __global float *d_Put,  
    __global float *d_S,    
    __global float *d_X,    
    __global float *d_T,    
    float R,                
    float V,                
    unsigned int optN
){
    for(unsigned int opt = get_global_id(0); opt < optN; opt += get_global_size(0))
        BlackScholesBody(
            &d_Call[opt],
            &d_Put[opt],
            d_S[opt],
            d_X[opt],
            d_T[opt],
            R,
            V
        );
}
