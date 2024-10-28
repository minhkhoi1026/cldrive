//{"Nh":3,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_sep3_x(global float* input, constant float* h, global float* output, const int Nh) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  int Nx = get_global_size(0);
  int Ny = get_global_size(1);
  int Nz = get_global_size(2);

  float res = 0.f;

  const int h_start = ((i + Nh / 2) >= Nx) ? i + Nh / 2 + 1 - Nx : 0;
  const int h_end = ((i - Nh / 2) < 0) ? i + Nh / 2 + 1 : Nh;
  const int start = i + Nh / 2;

  for (int ht = h_start; ht < h_end; ++ht)
    res += h[hook(1, ht)] * input[hook(0, start - ht + j * Nx + k * Nx * Ny)];

  output[hook(2, i + j * Nx + k * Nx * Ny)] = res;
}