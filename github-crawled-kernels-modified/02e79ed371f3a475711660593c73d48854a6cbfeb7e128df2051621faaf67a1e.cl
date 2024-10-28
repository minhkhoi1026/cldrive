//{"imageA":0,"itrs":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void foo(read_only image2d_t imageA, int itrs) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);
  for (int i = 0; i < itrs; ++i) {
    int2 coords = (int2)(x, y);
    float4 valueA = read_imagef(imageA, sampler, coords);
  }
  float4 valueB = read_imagef(imageA, sampler, (int2)(0, 0));
}