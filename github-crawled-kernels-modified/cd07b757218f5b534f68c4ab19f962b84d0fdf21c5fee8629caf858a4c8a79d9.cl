//{"dest":1,"srce":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clNormalize(read_only image2d_t srce, write_only image2d_t dest) {
  const sampler_t sampler = 0 | 0x10 | 4;
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 idx = (int2)(x, y);
  write_imagef(dest, idx, normalize(read_imagef(srce, sampler, idx)));
}