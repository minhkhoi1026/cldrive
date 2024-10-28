//{"A":0,"B":1,"C":2,"heightA":4,"widthA":3,"widthB":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMultiplication(global float* A, global float* B, global float* C, int widthA, int heightA, int widthB) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  float value = 0;

  if (j < heightA && i < widthB) {
    for (int k = 0; k < widthA; k++) {
      value += A[hook(0, k + j * widthA)] * B[hook(1, k * widthB + i)];
    }
    C[hook(2, i + widthB * j)] = value;
  }
}