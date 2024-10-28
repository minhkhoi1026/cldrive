//{"I":0,"O":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2D_naive(global float* I, global float* O) {
  const int ix = get_global_id(0) + 1;
  const int iy = get_global_id(1) + 1;
  const int nx = get_global_size(0) + 2;

  int i = iy * nx + ix;

  O[hook(1, i)] = (I[hook(0, i - nx - 1)] + I[hook(0, i - nx)] + I[hook(0, i - nx + 1)] + I[hook(0, i - 1)] + I[hook(0, i)] + I[hook(0, i + 1)] + I[hook(0, i + nx - 1)] + I[hook(0, i + nx)] + I[hook(0, i + nx + 1)]) * 0.11111111111f;
}