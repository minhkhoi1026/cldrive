//{"abs_nabla_f":1,"f":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void gradient(read_only image2d_t f, write_only image2d_t abs_nabla_f) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float4 f_x = read_imagef(f, sampler, coord + (int2)(1, 0)) - read_imagef(f, sampler, coord - (int2)(1, 0));

  float4 f_y = read_imagef(f, sampler, coord + (int2)(0, 1)) - read_imagef(f, sampler, coord - (int2)(0, 1));

  float res = f_x.x;
  float4 float3 = (float4)(res, res, res, res);
  write_imagef(abs_nabla_f, coord, float3);
}