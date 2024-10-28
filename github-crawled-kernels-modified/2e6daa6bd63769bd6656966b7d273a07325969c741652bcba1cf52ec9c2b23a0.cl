//{"Nx":2,"Ny":3,"h":1,"input":0,"output":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate2d_short(read_only image2d_t input, global float* h, const int Nx, const int Ny, write_only image2d_t output) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);
  int j0 = get_global_id(1);

  float res = 0.f;

  for (int i = 0; i < Nx; ++i) {
    for (int j = 0; j < Ny; ++j) {
      float dx = -.5f * (Nx - 1) + i;
      float dy = -.5f * (Ny - 1) + j;

      res += h[hook(1, i + Nx * j)] * read_imageui(input, sampler, (float2)(i0 + dx, j0 + dy)).x;
    }
  }
  write_imageui(output, (int2)(i0, j0), (uint4)(res, 0, 0, 0));
}