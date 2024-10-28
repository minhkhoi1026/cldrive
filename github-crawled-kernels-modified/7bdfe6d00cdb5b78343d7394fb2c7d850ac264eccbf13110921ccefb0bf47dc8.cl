//{"A":0,"n":2,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global unsigned int* A, float2 val, unsigned int n) {
  vstorea_half2(val, n, (global float*)A);
  vstorea_half2_rte(val, n + 1, (global float*)A);
  vstorea_half2_rtz(val, n + 2, (global float*)A);
}