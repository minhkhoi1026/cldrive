//{"a":2,"a_T":3,"heightA":0,"widthA":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixTranspose(const int heightA, const int widthA, global const float* a, global float* a_T) {
  int alpha = 8;
  const int colA = get_global_id(0) * alpha;
  const int rowA = get_global_id(1) * alpha;

  if (rowA < heightA && colA < widthA) {
    a_T[hook(3, (rowA + 0) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 0))];
    a_T[hook(3, (rowA + 0) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 0))];

    a_T[hook(3, (rowA + 1) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 1))];
    a_T[hook(3, (rowA + 1) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 1))];

    a_T[hook(3, (rowA + 2) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 2))];
    a_T[hook(3, (rowA + 2) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 2))];

    a_T[hook(3, (rowA + 3) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 3))];
    a_T[hook(3, (rowA + 3) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 3))];

    a_T[hook(3, (rowA + 4) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 4))];
    a_T[hook(3, (rowA + 4) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 4))];

    a_T[hook(3, (rowA + 5) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 5))];
    a_T[hook(3, (rowA + 5) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 5))];

    a_T[hook(3, (rowA + 6) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 6))];
    a_T[hook(3, (rowA + 6) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 6))];

    a_T[hook(3, (rowA + 7) * widthA + (colA + 0))] = a[hook(2, (colA + 0) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 1))] = a[hook(2, (colA + 1) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 2))] = a[hook(2, (colA + 2) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 3))] = a[hook(2, (colA + 3) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 4))] = a[hook(2, (colA + 4) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 5))] = a[hook(2, (colA + 5) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 6))] = a[hook(2, (colA + 6) * heightA + (rowA + 7))];
    a_T[hook(3, (rowA + 7) * widthA + (colA + 7))] = a[hook(2, (colA + 7) * heightA + (rowA + 7))];
  }
}