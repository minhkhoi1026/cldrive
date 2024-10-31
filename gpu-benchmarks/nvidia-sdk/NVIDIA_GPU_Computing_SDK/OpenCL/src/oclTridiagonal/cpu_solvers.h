
 
 

#ifndef _CPU_SOLVERS_
#define _CPU_SOLVERS_

#include <time.h>

void serial(float *a,float *b,float *c,float *d,float *x,int num_elements)
{
    c[num_elements-1]=0;
    c[0]=c[0]/b[0];
    d[0]=d[0]/b[0];

    for (int i = 1; i < num_elements; i++)
    {
      c[i]=c[i]/(b[i]-a[i]*c[i-1]);
      d[i]=(d[i]-d[i-1]*a[i])/(b[i]-a[i]*c[i-1]);  
    }

    x[num_elements-1]=d[num_elements-1];
	
    for (int i = num_elements-2; i >=0; i--)
    {
	  x[i]=d[i]-c[i]*x[i+1];
	}    
}

double serial_small_systems(float *a, float *b, float *c, float *d, float *x, int system_size, int num_systems)
{
	const unsigned int mem_size = sizeof(float) * num_systems * system_size;

	
	float *cc = (float*)malloc(mem_size);
	float *dd = (float*)malloc(mem_size);
	memcpy(cc, c, mem_size);
	memcpy(dd, d, mem_size);

    double time_spent = 0.0;
	shrDeltaT(0);
	for (int i = 0; i < num_systems; i++)
	{
        serial(&a[i*system_size],&b[i*system_size],&cc[i*system_size],&dd[i*system_size],&x[i*system_size],system_size);
	}
    time_spent = shrDeltaT(0);

	free(cc);
	free(dd);

    return time_spent;
}

#endif
