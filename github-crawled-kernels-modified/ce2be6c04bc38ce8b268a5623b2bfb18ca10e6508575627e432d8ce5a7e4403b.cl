//{"Nhx":5,"Nhy":6,"Nx":3,"Ny":4,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d(read_only image2d_t input, global float* h, global float* output, const int Nx, const int Ny, const int Nhx, const int Nhy) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);
  int j0 = get_global_id(1);

  float res = 0.f;

  for (int i = 0; i < Nhx; ++i) {
    for (int j = 0; j < Nhy; ++j) {
      float dx = -.5f * (Nhx - 1) + i;
      float dy = -.5f * (Nhy - 1) + j;

      res += h[hook(1, i + Nhx * j)] * read_imagef(input, sampler, (float2)(i0 + dx, j0 + dy)).x;
    }
  }
  output[hook(2, i0 + j0 * Nx)] = res;
}