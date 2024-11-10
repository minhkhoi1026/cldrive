
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



#pragma OPENCL EXTENSION cl_khr_local_int32_base_atomics : enable

__kernel void read_kernel ( __global uint4 *in,
                            __global uint  *out,
                                     uint   ni,
                                     uint   val,
                                     uint   nk )
{
   if( nk == 0 ) return;
   
           uint pcount = 0;
   __local uint lcount;
           uint i, idx;

   if( get_local_id(0) == 0)
       lcount=0;

   barrier( CLK_LOCAL_MEM_FENCE );

   for(int n=0; n<nk; n++)
      for( i=0, idx=get_global_id(0); i<ni; i++, idx+=get_global_size(0) )
      {
         if(in[hook(0, idx)].x == val) pcount++;
         if(in[hook(0, idx)].y == val) pcount++;
         if(in[hook(0, idx)].z == val) pcount++;
         if(in[hook(0, idx)].w == val) pcount++;
      }
      
     (void) atomic_add( &lcount, pcount );

     barrier( CLK_LOCAL_MEM_FENCE );

     if( get_local_id(0) == 0 )
        out[hook(1, get_group_id(0))] = lcount/nk;
}

__kernel void write_kernel ( __global uint  *in,
                             __global uint4 *out,
                                      uint  ni,
                                      uint  val,
                                      uint  nk )
{
   if( nk == 0 ) return;
   
   uint i, idx;
   uint4 pval = (uint4) (val, val, val, val);

   for(int n=0; n<nk; n++)
      for( i=0, idx=get_global_id(0); i<ni; i++, idx+=get_global_size(0) )
      {
         out[hook(1, idx)] = pval;
      }
}

                                  

