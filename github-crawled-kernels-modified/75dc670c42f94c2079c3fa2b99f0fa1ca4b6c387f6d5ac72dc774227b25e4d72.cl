//{"data":1,"sizes":2,"strides":3,"totalElements":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int dims = 4;
constant int sizes[4] = {50, 400, 5, 6};
constant int strides[4] = {12000, 30, 6, 1};

kernel void test(int totalElements, global float* data) {
  int offset = 0;
  int linearId = get_global_id(0);
  if (linearId >= totalElements) {
    return;
  }

  for (int d = dims - 1; d >= 0; d--) {
    int thisSize = sizes[hook(2, d)];
    int thisCoord = linearId % thisSize;
    offset += thisCoord * strides[hook(3, d)];
    linearId /= thisSize;
  }

  data[hook(1, offset)] = data[hook(1, offset)] + 1;
}