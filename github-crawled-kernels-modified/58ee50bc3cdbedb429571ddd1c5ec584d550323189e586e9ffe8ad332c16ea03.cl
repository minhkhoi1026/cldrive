//{"M":2,"N":3,"matrix":0,"mr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global const float* matrix, global float* mr, int M, int N) {
  int m = get_global_id(0);
  int n = get_global_id(1);

  mr[hook(1, n * M + m)] = matrix[hook(0, m * N + n)];
}