//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void D(global int* x) {
  int i = 10;

  __attribute__((opencl_unroll_hint)) do {
  }
  while (i--)
    ;
}