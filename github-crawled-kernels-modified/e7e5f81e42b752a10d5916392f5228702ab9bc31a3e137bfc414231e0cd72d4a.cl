//{"Nx":2,"Ny":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(constant float* input, global float* output, unsigned int Nx, unsigned int Ny) {
  const sampler_t volumeSampler = 1 | 2 |

                                  0x20;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  output[hook(1, i + Nx * j)] = 2.f * input[hook(0, i + Nx * j)];
}