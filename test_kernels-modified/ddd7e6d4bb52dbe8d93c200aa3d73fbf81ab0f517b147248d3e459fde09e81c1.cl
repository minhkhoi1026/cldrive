//{"mA":0,"mC":1,"mWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mataccKernel3(global float* mA, global float* mC, const unsigned int mWidth) {
  unsigned int g_id = get_group_id(0);
  unsigned int nunits = get_num_groups(0);
  const unsigned int bWidth = 64;
  const unsigned int size_t = 4096;
  unsigned int bs = mWidth / bWidth;
  float elt = 0.0;
  for (unsigned int br = 0; br < bs / nunits; br++) {
    for (unsigned int bc = 0; bc < bs; bc++) {
      for (unsigned int i = 0; i < bWidth; i++) {
        for (unsigned int j = 0; j < bWidth; j++) {
          elt += mA[hook(0, br * bWidth * mWidth + bc * bWidth + j + mWidth * i)];
        }
      }
    }
  }
  mC[hook(1, g_id)] = elt;
}