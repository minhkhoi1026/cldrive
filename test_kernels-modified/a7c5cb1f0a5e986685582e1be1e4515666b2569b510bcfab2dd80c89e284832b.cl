//{"diag_A_inv":0,"size":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void diag_precond(global const float* diag_A_inv, global float* x, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0))
    x[hook(1, i)] *= diag_A_inv[hook(0, i)];
}