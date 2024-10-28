//{"a":0,"b":1,"m":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* a, global int* b, int m, int n) {
  if (m > 0) {
    for (int i = 0; i < n; ++i) {
      a[hook(0, i)] += b[hook(1, i)];
    }
  }
}