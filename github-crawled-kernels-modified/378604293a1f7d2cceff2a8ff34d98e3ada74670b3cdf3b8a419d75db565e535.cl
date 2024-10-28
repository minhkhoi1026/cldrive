//{"matrixA":1,"matrixLogA":2,"vectorY":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void costFunctionPartLog(global int* vectorY, global double* matrixA, global double* matrixLogA) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int width = get_global_size(0);

  double f = matrixA[hook(1, j * width + i)];
  if (i != vectorY[hook(0, j)])
    f = 1.0f - f;
  matrixLogA[hook(2, j * width + i)] = -log(f);
}