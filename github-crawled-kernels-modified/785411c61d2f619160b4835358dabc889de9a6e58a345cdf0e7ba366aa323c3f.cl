//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matadd(global const float* A, global const float* B, global float* C) {
  size_t X = get_global_id(0);
  size_t Y = get_global_id(1);
  size_t Idx = Y * get_global_size(0) + X;

  C[hook(2, Idx)] = A[hook(0, Idx)] + B[hook(1, Idx)];
}