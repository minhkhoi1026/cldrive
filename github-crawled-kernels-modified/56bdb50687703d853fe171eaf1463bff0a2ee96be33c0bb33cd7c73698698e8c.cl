//{"Nh":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_2_x(global float* input, global float* output, const int Nh) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  int Nx = get_global_size(0);

  float res = (__builtin_inff());

  int start = i - Nh / 2;

  const int h_start = max(0, Nh / 2 - i);
  const int h_end = min(Nh, Nx - i + Nh / 2);

  for (int ht = h_start; ht < h_end; ++ht)
    res = fmin(res, input[hook(0, start + ht + j * Nx)]);

  output[hook(1, i + j * Nx)] = res;
}