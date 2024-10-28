//{"a":0,"b":1,"c":2,"kernelInstrArrayPointer":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findAll(global const int* a, global const int* b, global int* c, global int* kernelInstrArrayPointer) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int widthBig = kernelInstrArrayPointer[hook(3, 0)];

  if (a[hook(0, y * widthBig + x)] == b[hook(1, 0)]) {
    int cacheSmall, cacheBig;
    int heightBig = kernelInstrArrayPointer[hook(3, 1)];
    int widthSmall = kernelInstrArrayPointer[hook(3, 2)];
    int heightSmall = kernelInstrArrayPointer[hook(3, 3)];

    for (int i = 0; i < heightSmall; i++) {
      cacheSmall = i * widthSmall;
      cacheBig = (y + i) * widthBig + x;
      for (int j = 0; j < widthSmall; j++) {
        if (a[hook(0, cacheBig + j)] != b[hook(1, cacheSmall + j)]) {
          return;
        }
      }
    }

    atomic_add(&kernelInstrArrayPointer[hook(3, 4)], 2);
    int p = kernelInstrArrayPointer[hook(3, 4)];
    c[hook(2, p)] = x;
    c[hook(2, p + 1)] = y;
  }
}