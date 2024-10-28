//{"one":0,"two":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* one, global float* two) {
  two[hook(1, get_global_id(0))] = one[hook(0, get_global_id(0))] + 5;
}