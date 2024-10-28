//{"A":0,"B":1,"C":2,"SX":3,"SY":4,"SZ":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void boxadd(global const float* A, global const float* B, global float* C, int SX, int SY, int SZ) {
  size_t X = get_global_id(0);
  if (X >= SX)
    return;
  size_t Y = get_global_id(1);
  if (Y >= SY)
    return;
  size_t Z = get_global_id(2);
  if (Z >= SZ)
    return;

  size_t Idx = Z * SY * SX + Y * SX + X;

  C[hook(2, Idx)] = A[hook(0, Idx)] + B[hook(1, Idx)];
}