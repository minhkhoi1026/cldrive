//{"dst":1,"scale":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_bool_cross_basic_block(global int* src, global int* dst, int scale) {
  int id = (int)get_global_id(0);

  bool isRedRow = false;
  bool isRed;
  int val = src[hook(0, id)];
  for (unsigned int i = 0; i < scale; i++, isRedRow = !isRedRow) {
    if (isRedRow) {
      isRed = false;
      for (unsigned int j = 0; j < scale; j++, isRed = !isRed) {
        if (isRed) {
          val++;
        }
      }
    }
  }
  dst[hook(1, id)] = val;
}