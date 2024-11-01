


#define IA 16807    			
#define IM 2147483647 			
#define AM (1.0/IM) 			
#define IQ 127773
#define IR 2836
#define NTAB 4
#define NDIV (1 + (IM - 1)/ NTAB)
#define EPS 1.2e-7
#define RMAX (1.0 - EPS)
#define FACTOR 60			
#define GROUP_SIZE 64
#define PI 3.14






float ran1(int idum, __local int *iv)
{
    int j;
    int k;
    int iy = 0;
    
    int tid = get_local_id(0);

    for(j = NTAB; j >=0; j--)			
    {
        k = idum / IQ;
        idum = IA * (idum - k * IQ) - IR * k;

        if(idum < 0)
            idum += IM;

        if(j < NTAB)
            iv[NTAB* tid + j] = idum;
    }
    iy = iv[0];


    k = idum / IQ;
    idum = IA * (idum - k * IQ) - IR * k;

    if(idum < 0)
        idum += IM;

    j = iy / NDIV;
    iy = iv[NTAB * tid + j];
    return (AM * iy);	
}



float2 BoxMuller(float2 uniform)
{
    float r = sqrt(-2 * log(uniform.x));
    float theta = 2 * PI * uniform.y;
    return (float2)(r * sin(theta), r * cos(theta));
}