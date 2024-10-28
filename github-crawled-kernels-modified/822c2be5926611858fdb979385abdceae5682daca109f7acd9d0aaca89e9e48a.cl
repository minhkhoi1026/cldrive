//{"binary":2,"n":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarize_kernel(global float* x, int n, global float* binary) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= n)
    return;
  binary[hook(2, i)] = (x[hook(0, i)] >= 0) ? 1 : -1;
}