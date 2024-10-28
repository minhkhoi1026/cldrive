//{"dest":2,"val":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void set_values1(int x, int y, write_only image2d_t dest, unsigned int val) {
  int2 pos = (int2)(get_global_id(0) + x, get_global_id(1) + y);
  write_imageui(dest, pos, val);
}