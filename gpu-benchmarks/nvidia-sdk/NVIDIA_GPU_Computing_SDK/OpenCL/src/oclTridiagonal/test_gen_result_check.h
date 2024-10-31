
 
 

#ifndef _TEST_GEN_RESULT_CHECK_
#define _TEST_GEN_RESULT_CHECK_ 

int log2(int n)
{
	int res = 0;
	while (n > 1) { n >>= 1; res++; }
	return res;
}

float rand01()
{
    return float(rand())/float(RAND_MAX);
}

void test_gen_cyclic(float *a, float *b, float *c, float *d, float *x, int system_size, int choice)
{
    
    if (choice==0)
    {
      for (int j = 0; j < system_size; j++)
	  {
		a[j]=(float)j;
		b[j]=(float)(j+1);
		c[j]=(float)(j+1);

		d[j]=(float)(j+1);
		x[j]=0.0f;
	  }
      a[0]=0.0f;
      c[system_size-1] = 0.0f;
    }

    
    if (choice==1)
    {
      for (int j = 0; j < system_size; j++)
	  {
		b[j]=rand01();
		a[j]=rand01();
		c[j]=rand01();
		d[j]=rand01();
		x[j]=0.0f;
	  }      
      a[0] = 0.0f;
      c[system_size-1] = 0.0f;
    }

    
    if (choice==2)
    {
      for (int j = 0; j < system_size; j++)
	  {
        float ratio = rand01();
		b[j]=rand01();
		a[j]=b[j]*ratio*0.5f;
		c[j]=b[j]*(1.0f-ratio)*0.5f;
		d[j]=rand01();
		x[j]=0.0f;
	  }      
      a[0] = 0.0f;
      c[system_size-1] = 0.0f;
    }

    
    if (choice==3)
    {
      for (int j = 0; j < system_size; j++)
	  {
		b[j]=(float)rand01()+3.0f;
		a[j]=(float)rand01()+3.0f;
		c[j]=(float)rand01()+3.0f;
		d[j]=(float)rand01()+3.0f;
		x[j]=0.0f;
	  }      
      a[0] = 0.0f;
      c[system_size-1] = 0.0f;

    }

    
    if (choice==4)
    {
        
        file_read_array(a, system_size, "a256.txt");
        file_read_array(b, system_size, "b256.txt");
        file_read_array(c, system_size, "c256.txt");
        file_read_array(d, system_size, "d256.txt");
        a[0] = 0.0f;
        c[system_size-1] = 0.0f;
    }

    if (choice==5)
    {
        
        file_read_array(a, system_size, "a512.txt");
        file_read_array(b, system_size, "b512.txt");
        file_read_array(c, system_size, "c512.txt");
        file_read_array(d, system_size, "d512.txt");
        a[0] = 0.0f;
        c[system_size-1] = 0.0f;
    }

}

void test_gen_doubling(float *a,float *b,float *c,float *d,float *x,int system_size,int choice)
{
    
    if (choice==0)
    {
      for (int j = 0; j < system_size; j++)
	  {
		a[j]=(float)j;
		b[j]=(float)(j+1);
		c[j]=(float)(j+1);
		d[j]=(float)(j+1);
		x[j]=0.0f;
	  }
      a[0] = 0.0f;
      c[system_size-1] = 1.0f;
    }

    
    if (choice==1)
    {
      for (int j = 0; j < system_size; j++)
	  {
		b[j]=rand01();
		a[j]=rand01();
		c[j]=rand01();
		d[j]=rand01();
		x[j]=0.0f;
	  }      
      a[0] = 0.0f;
      c[system_size-1] = 1.0f;
    }

    
    if (choice==2)
    {
      for (int j = 0; j < system_size; j++)
	  {
        float ratio = rand01();
		b[j]=rand01();
		a[j]=b[j]*ratio*0.5f;
		c[j]=b[j]*(1.0f-ratio)*0.5f;
		d[j]=rand01();
		x[j]=0.0f;
	  }      
      a[0] = 0.0f;
      c[system_size-1] = 1.0f;
    }

    
    if (choice==3)
    {
      for (int j = 0; j < system_size; j++)
	  {
		b[j]=rand01()+3.0f;
		a[j]=rand01()+3.0f;
		c[j]=rand01()+3.0f;
		d[j]=rand01()+3.0f;
		x[j]=0.0f;
	  }      
      a[0] = 0.0f;
      c[system_size-1] = 1.0f;
    }

    
    if (choice==4)
    {
        
        file_read_array(a, system_size, "a256.txt");
        file_read_array(b, system_size, "b256.txt");
        file_read_array(c, system_size, "c256.txt");
        file_read_array(d, system_size, "d256.txt");
        a[0] = 0.0f;
        c[system_size-1] = 1.0f;
    }

    if (choice==5)
    {
        
        file_read_array(a, system_size, "a512.txt");
        file_read_array(b, system_size, "b512.txt");
        file_read_array(c, system_size, "c512.txt");
        file_read_array(d, system_size, "d512.txt");
        a[0] = 0.0f;
        c[system_size-1] = 0.0f;
    }
}

float compare(float *x1, float *x2, int num_elements)
{
    float mean = 0.0f; 
    float root = 0.0f;
    float max = 0.0f; 
    for (int i = 0; i < num_elements; i++)
    {
      root += (x1[i] - x2[i]) * (x1[i] - x2[i]);
      mean += fabs(x1[i] - x2[i]);
      if(fabs(x1[i] - x2[i])>max) max = fabs(x1[i] - x2[i]);
    }
    mean /= (float)num_elements;
    root /= (float)num_elements;
    root = sqrt(root); 
    
    
    return root;
}

void compare_small_systems(float *x1,float *x2,int system_size, int num_systems)
{
    float avg_of_all_systems =0;

    for (int i = 0; i < num_systems; i++)
    {
      float diff = compare(&x1[i * system_size], &x2[i * system_size], system_size);
      
      

      avg_of_all_systems = avg_of_all_systems + diff;
      
      
          
    }

    avg_of_all_systems /= (float)num_systems;
    shrLog("  err = %.4f\n\n", avg_of_all_systems * 1.0e6);
}

#endif
