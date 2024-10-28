//{"A":0,"N":1,"k":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_kk(global float* A, unsigned int N, unsigned int k) {
  A[hook(0, k * N + k)] = sqrt(A[hook(0, k * N + k)]);
}