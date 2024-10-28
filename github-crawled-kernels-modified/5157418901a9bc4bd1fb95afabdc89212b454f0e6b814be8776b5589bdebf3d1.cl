//{"fac":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stencil(global double* in, global double* out, double fac) {
  int i = get_global_id(0) + 1;
  int j = get_global_id(1) + 1;
  int k = get_global_id(2) + 1;
  int sz = get_global_size(0) + 2;
  out[hook(1, i * sz * sz + j * sz + k)] = (in[hook(0, i * sz * sz + (j - 1) * sz + k)] + in[hook(0, i * sz * sz + (j + 1) * sz + k)] + in[hook(0, (i - 1) * sz * sz + j * sz + k)] + in[hook(0, (i + 1) * sz * sz + j * sz + k)] + in[hook(0, (i - 1) * sz * sz + (j - 1) * sz + k)] + in[hook(0, (i - 1) * sz * sz + (j + 1) * sz + k)] + in[hook(0, (i + 1) * sz * sz + (j - 1) * sz + k)] + in[hook(0, (i + 1) * sz * sz + (j + 1) * sz + k)] + in[hook(0, i * sz * sz + (j - 1) * sz + (k - 1))] + in[hook(0, i * sz * sz + (j + 1) * sz + (k - 1))] + in[hook(0, (i - 1) * sz * sz + j * sz + (k - 1))] + in[hook(0, (i + 1) * sz * sz + j * sz + (k - 1))] + in[hook(0, (i - 1) * sz * sz + (j - 1) * sz + (k - 1))] + in[hook(0, (i - 1) * sz * sz + (j + 1) * sz + (k - 1))] + in[hook(0, (i + 1) * sz * sz + (j - 1) * sz + (k - 1))] + in[hook(0, (i + 1) * sz * sz + (j + 1) * sz + (k - 1))] + in[hook(0, i * sz * sz + (j - 1) * sz + (k + 1))] + in[hook(0, i * sz * sz + (j + 1) * sz + (k + 1))] + in[hook(0, (i - 1) * sz * sz + j * sz + (k + 1))] + in[hook(0, (i + 1) * sz * sz + j * sz + (k + 1))] + in[hook(0, (i - 1) * sz * sz + (j - 1) * sz + (k + 1))] + in[hook(0, (i - 1) * sz * sz + (j + 1) * sz + (k + 1))] + in[hook(0, (i + 1) * sz * sz + (j - 1) * sz + (k + 1))] + in[hook(0, (i + 1) * sz * sz + (j + 1) * sz + (k + 1))] + in[hook(0, i * sz * sz + j * sz + (k - 1))] + in[hook(0, i * sz * sz + j * sz + (k + 1))]) * fac;
}