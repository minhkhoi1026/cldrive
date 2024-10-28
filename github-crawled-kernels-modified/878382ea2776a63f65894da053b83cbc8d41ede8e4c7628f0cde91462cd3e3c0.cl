//{"Nx":1,"output":0,"volume":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_img(global unsigned int* output, unsigned int Nx, read_only image3d_t volume) {
  const sampler_t sampler = 1 | 2 |

                            0x20;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  output[hook(0, i + Nx * j)] = (unsigned int)read_imageui(volume, sampler, (float4)(0.f, 0.f, 0.f, 0.f)).x;
}