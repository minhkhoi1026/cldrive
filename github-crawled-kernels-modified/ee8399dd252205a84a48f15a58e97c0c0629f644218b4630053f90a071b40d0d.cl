//{"Nhx":6,"Nhy":7,"Nhz":8,"Nx":3,"Ny":4,"Nz":5,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve3d(read_only image3d_t input, global float* h, global float* output, const int Nx, const int Ny, const int Nz, const int Nhx, const int Nhy, const int Nhz) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);
  int j0 = get_global_id(1);
  int k0 = get_global_id(2);

  float res = 0.f;

  for (int i = 0; i < Nhx; ++i) {
    for (int j = 0; j < Nhy; ++j) {
      for (int k = 0; k < Nhz; ++k) {
        float dx = -.5f * (Nhx - 1) + i;
        float dy = -.5f * (Nhy - 1) + j;
        float dz = -.5f * (Nhz - 1) + k;

        res += h[hook(1, i + Nhx * j + Nhx * Nhy * k)] * read_imagef(input, sampler, (float4)(i0 + dx, j0 + dy, k0 + dz, 0)).x;
      }
    }
  }

  output[hook(2, i0 + j0 * Nx + k0 * Nx * Ny)] = res;
}