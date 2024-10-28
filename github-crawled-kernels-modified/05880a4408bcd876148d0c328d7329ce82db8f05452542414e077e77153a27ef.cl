//{"Nh":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_y(global float* input, global float* output, const int Nh) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  int Nx = get_global_size(0);
  int Ny = get_global_size(1);

  float res = 0.f;
  float sum_val = 0.f;

  int start = j - Nh / 2;

  const int h_start = ((j - Nh / 2) < 0) ? Nh / 2 - j : 0;
  const int h_end = ((j + Nh / 2) >= Ny) ? Nh - (j + Nh / 2 - Ny + 1) : Nh;

  for (int ht = h_start; ht < h_end; ++ht) {
    float val = native_exp((float)(-10.f * (ht - Nh / 2.f) * (ht - Nh / 2.f) / Nh / Nh));
    sum_val += val;
    res += val * input[hook(0, i + (start + ht) * Nx)];
  }

  output[hook(1, i + j * Nx)] = res / sum_val;
}