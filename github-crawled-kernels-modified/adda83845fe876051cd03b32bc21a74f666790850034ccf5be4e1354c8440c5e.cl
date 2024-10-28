//{"a":0,"b":1,"c":2,"iNumElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpuCoreTest(global const float* a, global const float* b, global float* c, int iNumElements) {
  int id = get_global_id(0);
  int blocksize = 65536 / iNumElements;

  for (int iy = 0; iy < 100; iy++) {
    for (int i0 = id * blocksize; i0 < (id + 1) * blocksize; i0++) {
      c[hook(2, i0)] = a[hook(0, i0)] + b[hook(1, i0)];
    }
  }
}