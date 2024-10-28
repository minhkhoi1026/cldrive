//{"tmp_var":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int maximum(int a, int b, int c) {
  int k;
  if (a <= b)
    k = b;
  else
    k = a;

  if (k <= c)
    return (c);
  else
    return (k);
}

kernel void dummy_kernel_gpu(global int* tmp_var) {
  int tx = get_global_id(0);
  if (tx == 0)
    *tmp_var = *tmp_var + 1;
}