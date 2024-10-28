//{"N":2,"a":0,"alpha":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void s_vector_scale_mem(global float* a, global float* alpha, int N) {
  int i = get_global_id(0);

  if (i < N)
    a[hook(0, i)] *= alpha[hook(1, 0)];
}