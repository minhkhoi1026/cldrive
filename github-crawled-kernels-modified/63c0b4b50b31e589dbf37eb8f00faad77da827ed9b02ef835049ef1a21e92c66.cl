//{"A":0,"C":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy2Dfloat4(global float4* A, global float4* C) {
  int idx = get_global_id(0);
  int idy = get_global_id(1);
  C[hook(1, (idy) * 1024 + (idx))] = A[hook(0, (idy) * 1024 + (idx))];
}