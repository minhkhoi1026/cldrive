//{"A":0,"n":2,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global unsigned int* A, float2 val, unsigned int n) {
  unsigned int arr[5];
  float* cast = (private float*)arr;
  vstorea_half2(val, n, cast);
  vstorea_half2_rte(val, n + 1, cast);
  vstorea_half2_rtz(val, n + 2, cast);
  *A = *(unsigned int*)arr;
}