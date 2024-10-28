//{"A":0,"C":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy2Dfloat4(global float4* A, global float4* C) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  C[hook(1, (x) * 1024 + (y))] = A[hook(0, (x) * 1024 + (y))];
}