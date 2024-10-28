//{"height":3,"integral_img":0,"overflow":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = (0 | 2 | 0x10);
kernel void vert_sum(global uint4* integral_img, global int* overflow, int width, int height) {
  int x = get_global_id(0);
  uint4 sum = 0;
  for (int i = 0; i < height; i++) {
    if (any((uint4)0xffffffff - integral_img[hook(0, i * width + x)] < sum))
      atomic_inc(overflow);
    integral_img[hook(0, i * width + x)] += sum;
    sum = integral_img[hook(0, i * width + x)];
  }
}