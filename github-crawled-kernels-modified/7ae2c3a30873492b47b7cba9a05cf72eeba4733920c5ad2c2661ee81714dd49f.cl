//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void B(global float* a, global float* b, const int c) {
  int d = get_global_id(0);

  for (int i = 0; i < d * 1000; ++i)
    a[hook(0, d)] += 1;
}