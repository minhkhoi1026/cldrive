//{"Nx":2,"Nx0":5,"Ny":3,"Ny0":6,"Nz":4,"h":1,"input":0,"output":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate3d_float_buf(read_only image3d_t input, global float* h, const int Nx, const int Ny, const int Nz, const int Nx0, const int Ny0, global float* output) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);
  int j0 = get_global_id(1);
  int k0 = get_global_id(2);

  float res = 0.f;

  for (int i = 0; i < Nx; ++i) {
    for (int j = 0; j < Ny; ++j) {
      for (int k = 0; k < Nz; ++k) {
        float dx = -.5f * (Nx - 1) + i;
        float dy = -.5f * (Ny - 1) + j;
        float dz = -.5f * (Nz - 1) + k;

        res += h[hook(1, i + Nx * j + Nx * Ny * k)] * read_imagef(input, sampler, (float4)(i0 + dx, j0 + dy, k0 + dz, 0)).x;
      }
    }
  }

  output[hook(7, i0 + Nx0 * j0 + Nx0 * Ny0 * k0)] = res;
}