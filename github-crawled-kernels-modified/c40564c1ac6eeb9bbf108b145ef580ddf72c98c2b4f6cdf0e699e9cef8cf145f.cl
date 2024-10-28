//{"Nh":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_3_z(global float* input, global float* output, const int Nh) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  int Nx = get_global_size(0);
  int Ny = get_global_size(1);
  int Nz = get_global_size(2);

  float res = -(__builtin_inff());

  int start = k - Nh / 2;

  const int h_start = max(0, Nh / 2 - k);
  const int h_end = min(Nh, Nz - k + Nh / 2);

  for (int ht = h_start; ht < h_end; ++ht)
    res = fmax(res, input[hook(0, i + j * Nx + (start + ht) * Nx * Ny)]);

  output[hook(1, i + j * Nx + k * Nx * Ny)] = res;
}