//{"vector_field":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF2DInit(read_only image2d_t volume, write_only image2d_t vector_field) {
  int2 pos = {get_global_id(0), get_global_id(1)};

  float f10 = read_imagef(volume, sampler, pos + (int2)(1, 0)).x;
  float f_10 = read_imagef(volume, sampler, pos - (int2)(1, 0)).x;
  float f01 = read_imagef(volume, sampler, pos + (int2)(0, 1)).x;
  float f0_1 = read_imagef(volume, sampler, pos - (int2)(0, 1)).x;

  float4 gradient = {(f10 - f_10) / 2.0f, (f01 - f0_1) / 2.0f, 0, 0};

  write_imagef(vector_field, pos, gradient);
}