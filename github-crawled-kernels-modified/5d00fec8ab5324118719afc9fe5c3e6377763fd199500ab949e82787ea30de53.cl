//{"avrg":2,"ioim":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void averageArr(global float* ioim, int size, global float* avrg) {
  float sum = 0;
  int tot = 0;
  for (size_t idx = 0; idx < size; idx++) {
    const float dt = *ioim++;
    if (!isnan(dt)) {
      tot++;
      sum += dt;
    }
  }
  *avrg = tot ? sum / tot : __builtin_astype((2147483647), float);
}