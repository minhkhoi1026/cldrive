//{"i1":0,"i2":1,"i3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void addTwoImages(read_only image3d_t i1, read_only image3d_t i2, global float* i3) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  float v = read_imagef(i1, sampler, pos).x + read_imagef(i2, sampler, pos).x;

  i3[hook(2, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = v;
}