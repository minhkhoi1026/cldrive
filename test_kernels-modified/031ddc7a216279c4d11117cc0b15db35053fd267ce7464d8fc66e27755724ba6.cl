//{"a":2,"a_T":3,"heightA":0,"widthA":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixTranspose(const int heightA, const int widthA, global const float* a, global float* a_T) {
  int alpha = 4;
  const int rowA = get_global_id(0) * alpha;
  if (rowA < heightA) {
    for (int colA = 0; colA < widthA; colA++) {
      a_T[hook(3, (rowA + 0) * widthA + colA)] = a[hook(2, colA * heightA + (rowA + 0))];
      a_T[hook(3, (rowA + 1) * widthA + colA)] = a[hook(2, colA * heightA + (rowA + 1))];
      a_T[hook(3, (rowA + 2) * widthA + colA)] = a[hook(2, colA * heightA + (rowA + 2))];
      a_T[hook(3, (rowA + 3) * widthA + colA)] = a[hook(2, colA * heightA + (rowA + 3))];
    }
  }
}