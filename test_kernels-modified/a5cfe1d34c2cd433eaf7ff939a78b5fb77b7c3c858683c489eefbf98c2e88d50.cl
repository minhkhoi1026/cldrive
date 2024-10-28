//{"_buf0":0,"_buf1":1,"count":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float pow3add4(float x) {
  return pow(x, 3.0f) + 4.0f;
}

kernel void copy(global float* _buf0, global float* _buf1, const unsigned int count) {
  unsigned int index = get_local_id(0) + (32 * get_group_id(0));
  for (unsigned int i = 0; i < 4; i++) {
    if (index < count) {
      _buf0[hook(0, index)] = pow3add4(_buf1[hook(1, index)]);
      index += 8;
    }
  }
}