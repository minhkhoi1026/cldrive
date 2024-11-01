

__constant sampler_t imageSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST; 


__kernel void image2dCopy(__read_only image2d_t input, __write_only image2d_t output)
{
	int2 coord = (int2)(get_global_id(0), get_global_id(1));

	uint4 temp = read_imageui(input, imageSampler, coord);

	write_imageui(output, coord, temp);
}


__kernel void image3dCopy(__read_only image3d_t input, __write_only image2d_t output)
{
	int2 coord = (int2)(get_global_id(0), get_global_id(1));

	
	uint4 temp0 = read_imageui(input, imageSampler, (int4)(coord, 0, 0));

	
	uint4 temp1 = read_imageui(input, imageSampler, (int4)((int2)(get_global_id(0), get_global_id(1) - get_global_size(1)/2), 1, 0));
	
	write_imageui(output, coord, temp0 + temp1);
}

