//{"one":0,"out":2,"two":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_read(const int one, const int two, global int* out) {
  const int globalid = get_global_id(0);
  int sum = 0;
  int n = 0;
  while (n < 100000) {
    sum = (sum + one) % 1357 * two;
    n++;
  }

  out[hook(2, globalid)] = sum;
}