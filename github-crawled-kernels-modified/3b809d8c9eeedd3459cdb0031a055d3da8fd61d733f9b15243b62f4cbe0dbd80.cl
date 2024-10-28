//{"Nx":2,"Ny":3,"h":1,"input":0,"output":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate2d_float(read_only image2d_t input, global float* h, const int Nx, const int Ny, write_only image2d_t output) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);
  int j0 = get_global_id(1);

  float hMean = 0.f, dataMean = 0.f;
  float hVar = 0.f, dataVar = 0.f;
  float tmp;

  for (int i = 0; i < Nx; ++i)
    for (int j = 0; j < Ny; ++j) {
      float dx = -.5f * (Nx - 1) + i;
      float dy = -.5f * (Ny - 1) + j;

      tmp = h[hook(1, i + Nx * j)];

      hMean += tmp;
      hVar += tmp * tmp;

      tmp = read_imagef(input, sampler, (float2)(i0 + dx, j0 + dy)).x;
      dataMean += tmp;
      dataVar += tmp * tmp;
    }

  hMean *= 1.f / Nx / Ny;
  dataMean *= 1.f / Nx / Ny;

  hVar = 1.f * hVar / Nx / Ny - hMean * hMean;
  dataVar = 1.f * dataVar / Nx / Ny - dataMean * dataMean;

  float res = 0.f;

  for (int i = 0; i < Nx; ++i) {
    for (int j = 0; j < Ny; ++j) {
      float dx = -.5f * (Nx - 1) + i;
      float dy = -.5f * (Ny - 1) + j;

      res += (h[hook(1, i + Nx * j)] - hMean) * (read_imagef(input, sampler, (float2)(i0 + dx, j0 + dy)).x - dataMean);
    }
  }

  write_imagef(output, (int2)(i0, j0), (float4)(res, 0, 0, 0));
}