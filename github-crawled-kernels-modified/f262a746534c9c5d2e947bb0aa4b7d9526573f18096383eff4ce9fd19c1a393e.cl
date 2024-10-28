//{"A":0,"B":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float2* A, global unsigned int* B, unsigned int n) {
  A[hook(0, 0)] = vloada_half2(n, (global float*)B);
  A[hook(0, 1)] = vloada_half2(0, (global float*)B + 2);
}