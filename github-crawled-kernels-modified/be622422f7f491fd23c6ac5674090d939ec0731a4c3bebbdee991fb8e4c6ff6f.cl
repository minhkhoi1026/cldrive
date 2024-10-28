//{"d_MatA":1,"d_MatB":2,"d_cols":4,"d_rows":3,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matMatMultKernel(global double* output, global double* d_MatA, global double* d_MatB, global int* d_rows, global int* d_cols) {
  int globalIdx = get_global_id(0);
  int globalIdy = get_global_id(1);
  double sum = 0.0;
  int i;
  double tempA, tempB;
  for (i = 0; i < (*d_rows); i++) {
    tempA = d_MatA[hook(1, globalIdy * (*d_rows) + i)];
    tempB = d_MatB[hook(2, i * (*d_cols) + globalIdx)];
    sum += tempA * tempB;
  }
  output[hook(0, globalIdy * (*d_rows) + globalIdx)] = sum;
}