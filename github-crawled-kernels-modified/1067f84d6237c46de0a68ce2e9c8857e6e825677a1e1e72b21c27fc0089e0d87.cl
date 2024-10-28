//{"a":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(float global* a, const int n) {
  float sum = 0.0;
  for (int i = 0; i < n; i++)
    sum += a[hook(0, i)];
  a[hook(0, get_global_id(0))] = sum;
}