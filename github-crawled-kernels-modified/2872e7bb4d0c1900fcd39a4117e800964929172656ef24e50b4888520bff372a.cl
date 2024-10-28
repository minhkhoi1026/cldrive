//{"im1":0,"im2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void foo(read_only image2d_t im1, read_only image2d_t im2) {
  for (int l = 0; l < 30; ++l) {
    float4 s = read_imagef(im1, sampler, (int2)(0, 0));
  }

  float4 w = read_imagef(im2, sampler, (int2)(0, 0));
}