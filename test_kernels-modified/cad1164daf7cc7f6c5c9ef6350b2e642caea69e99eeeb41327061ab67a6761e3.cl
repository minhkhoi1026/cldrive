//{"data":0,"dir":3,"scratch":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DFT(global double* data, global double* scratch, const int size, unsigned int dir) {
  int idX = get_global_id(0);
  double2 TEMP = (double2)(0, 0);
  double2 W;

  int i;
  for (i = 0; i < size; i++) {
    W = (double2)(cos(6.283185307179586476925286766559 * idX * i / size), -sin(6.283185307179586476925286766559 * idX * i / size));
    TEMP.x += data[hook(0, 2 * i)] * W.x - data[hook(0, 2 * i + 1)] * W.y;
    TEMP.y += data[hook(0, 2 * i)] * W.y + data[hook(0, 2 * i + 1)] * W.x;
  }
  scratch[hook(1, 2 * idX)] = TEMP.x;
  scratch[hook(1, 2 * idX + 1)] = TEMP.y;
}