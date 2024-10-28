//{"fx":0,"fy":1,"fz":2,"vectorField":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void MGGVFFinish(read_only image3d_t fx, read_only image3d_t fy, read_only image3d_t fz, global float* vectorField) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  float4 value;
  value.x = read_imagef(fx, sampler, pos).x;
  value.y = read_imagef(fy, sampler, pos).x;
  value.z = read_imagef(fz, sampler, pos).x;
  value.w = length(value.xyz);

  vstore4(value, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), vectorField);
}