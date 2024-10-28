//{"mA":0,"mC":1,"mWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mataccKernel1(global float* mA, global float* mC, const unsigned int mWidth) {
  unsigned int g_id = get_group_id(0);
  unsigned int nunits = get_num_groups(0);
  float elt = 0.0;
  for (unsigned int i = 0; i < mWidth / nunits; i++) {
    for (unsigned int j = 0; j < mWidth; j++) {
      elt += mA[hook(0, i * mWidth + j)];
    }
  }
  mC[hook(1, g_id)] = elt;
}