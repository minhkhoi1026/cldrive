#include "macros.hpp"



#pragma OPENCL EXTENSION cl_khr_local_int32_base_atomics : enable

__kernel void read_kernel( __read_only image2d_t in,
                           __global    uint     *out,
                                       uint      np,
                                       uint      val,
                                       uint      nk )
{
   if( nk == 0 ) return;
   
   sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE |
                       CLK_ADDRESS_CLAMP_TO_EDGE |
                       CLK_FILTER_NEAREST;

           uint  pcount = 0;
   __local uint  lcount; 
           uint  i, idx;
           uint4 pix;
           int2  coord = ( int2 ) ( get_global_id(0), 0 );

   if( get_local_id(0) == 0 && get_local_id(1) == 0 )
      lcount=0;

   barrier( CLK_LOCAL_MEM_FENCE );

   for(int n=0; n<nk; n++)
      for( i=0, idx=get_global_id(1); i<np; i++, idx+=get_global_size(1) )
      {
         coord.y = idx;
         pix = read_imageui( in, sampler, coord );

         if( pix.x == val ) pcount++;
         if( pix.y == val ) pcount++;
         if( pix.z == val ) pcount++;
         if( pix.w == val ) pcount++;
      }

   (void) atomic_add( &lcount, pcount );

   barrier( CLK_LOCAL_MEM_FENCE );
   
   uint gid1D = get_group_id(1) * get_num_groups(0) + get_group_id(0);

   if( get_local_id(0) == 0 && get_local_id(1) == 0 )
      out[ gid1D ] = lcount / nk;
}

__kernel void write_kernel ( __global     uint     *in,
                             __write_only image2d_t out,
                                          uint      np,
                                          uint      val,
                                          uint      nk )
{
   if( nk == 0 ) return;
   
   uint4 pval;
   uint  i, idx;
   int2  coord = ( int2 ) ( get_global_id(0), 0 );

   pval = (uint4) ( val, val, val, val );

   for(int n=0; n<nk; n++)
      for( i=0, idx=get_global_id(1); i<np; i++, idx+=get_global_size(1) )
      {
         coord.y = idx;
         write_imageui( out, coord, pval );
      }
}
