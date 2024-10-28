//{"init_vector_field":1,"vector_field":2,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF3DInit(read_only image3d_t volume, global float* init_vector_field, global float* vector_field) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  float f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).x;
  float f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).x;
  float f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).x;
  float f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).x;
  float f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).x;
  float f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).x;

  float4 gradient = {0.5f * (f100 - f_100), 0.5f * (f010 - f0_10), 0.5f * (f001 - f00_1), 0};
  gradient.w = gradient.x * gradient.x + gradient.y * gradient.y + gradient.z * gradient.z;
  vstore4(gradient, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), init_vector_field);
  vstore3(gradient.xyz, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), vector_field);
}