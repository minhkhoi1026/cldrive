//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test1(global float a[], global float b[]) {
  for (int i = 0; i < 1000; i++) {
    a[hook(0, i)] = -i;
    b[hook(1, i)] = -i;
  }
}