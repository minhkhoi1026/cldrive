//{"a":2,"a_T":3,"heightA":0,"widthA":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixTranspose(const int heightA, const int widthA, global const float* a, global float* a_T) {
  const int rowA = get_global_id(0);
  const int colA = get_global_id(1);

  if (rowA < heightA && colA < widthA) {
    a_T[hook(3, rowA * widthA + colA)] = a[hook(2, colA * heightA + rowA)];
  }
}