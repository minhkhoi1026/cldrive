//{"sqrMag":1,"vectorField":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void createSqrMag(read_only image3d_t vectorField, global float* sqrMag) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  const float4 v = read_imagef(vectorField, sampler, pos);

  float mag = v.x * v.x + v.y * v.y + v.z * v.z;

  sqrMag[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = mag;
}