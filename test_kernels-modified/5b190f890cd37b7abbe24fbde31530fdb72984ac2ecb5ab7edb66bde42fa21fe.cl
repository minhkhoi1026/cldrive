//{"A":0,"B":1,"Result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simulationStep(global float* A, global float* B, global float* Result) {
  int idx = get_global_id(0);

  Result[hook(2, idx)] = A[hook(0, idx)] + B[hook(1, idx)];
}