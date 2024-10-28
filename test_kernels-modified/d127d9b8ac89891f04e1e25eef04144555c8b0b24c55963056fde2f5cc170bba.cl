//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_stress(global const int* in, global int* out) {
  const int globalid = get_global_id(0);
  int sum = 0;
  int n = 0;

  while (n < 10001) {
    sum = (sum + in[hook(0, n % 47)]) % (103070 * 7);
    n++;
  }
  out[hook(1, globalid)] = sum;
}