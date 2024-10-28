//{"Nx":2,"Ny":3,"input":0,"output_mean":4,"output_var":5,"xStride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mean_var_2d_float(read_only image2d_t input, const int xStride, const int Nx, const int Ny, global float* output_mean, global float* output_var) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);
  int j0 = get_global_id(1);

  float dataMean = 0.f, dataVar = 0.f;
  float tmp;

  for (int i = 0; i < Nx; ++i)
    for (int j = 0; j < Ny; ++j) {
      float dx = -.5f * (Nx - 1) + i;
      float dy = -.5f * (Ny - 1) + j;
      tmp = read_imagef(input, sampler, (float2)(i0 + dx, j0 + dy)).x;
      dataMean += tmp;
      dataVar += tmp * tmp;
    }

  dataMean *= 1.f / Nx / Ny;
  dataVar = 1.f * dataVar / Nx / Ny - dataMean * dataMean;

  output_mean[hook(4, i0 + xStride * j0)] = dataMean;

  output_var[hook(5, i0 + xStride * j0)] = dataVar;
}