//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smp = 0 | 2 | 0x20;
kernel void copy(read_only image2d_t in, write_only image2d_t out) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  float4 pixel = read_imagef(in, smp, pos);
  write_imagef(out, pos, pixel);
}