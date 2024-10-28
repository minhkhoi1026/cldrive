//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 2 | 0x10;
kernel void magesTest(read_only image2d_t src, write_only image2d_t dst) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 pixel = read_imagef(src, sampler, (int2)(x, y));
  write_imagef(dst, (int2)(x, y), pixel);
}