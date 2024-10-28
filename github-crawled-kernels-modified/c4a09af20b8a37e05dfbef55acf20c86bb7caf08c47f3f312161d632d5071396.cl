//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void convertToHU(read_only image3d_t input, global short* output) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int value = read_imageui(input, sampler, pos).x;
  value -= 1024;

  output[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value;
}