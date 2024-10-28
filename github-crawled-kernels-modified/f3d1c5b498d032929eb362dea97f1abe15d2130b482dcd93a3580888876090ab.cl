//{"a":0,"c":1,"iNumElements":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rowWriteTest(global const float* a, global float* c, int iNumElements) {
  int j = get_global_id(0);
  int i = get_global_id(1);
  volatile float tmp = 1.0;
  for (int iy = 0; iy < 1; iy++) {
    for (int i0 = 0; i0 < iNumElements; i0++) {
      c[hook(1, i * 1024 + j * 1 + i0)] = tmp;
    }
  }
}