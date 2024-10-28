//{"mask":3,"mask_num":2,"n":0,"scale":4,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mask_kernel(int n, global float* x, float mask_num, global float* mask, float scale) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < n && mask[hook(3, i)] == mask_num)
    x[hook(1, i)] *= scale;
}