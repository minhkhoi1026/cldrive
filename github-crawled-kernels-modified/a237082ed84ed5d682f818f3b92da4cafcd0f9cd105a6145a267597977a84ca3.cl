//{"matrixA":0,"matrixB":1,"matrixHeight":3,"matrixWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixTranspose_int(global int* matrixA, global int* matrixB, int matrixWidth, int matrixHeight) {
  int idx0 = get_global_id(0);
  int idx1 = get_global_id(1);

  matrixB[hook(1, idx1 * matrixWidth + idx0)] = matrixA[hook(0, idx0 * matrixHeight + idx1)];
}