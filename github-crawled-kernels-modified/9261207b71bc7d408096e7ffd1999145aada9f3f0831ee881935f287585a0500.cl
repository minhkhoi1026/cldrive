//{"_buf0":0,"count":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int x_if_odd_else_y(int x, int y) {
  if (x & 1)
    return x;
  else
    return y;
}

kernel void bind_custom_function1(global int* _buf0, const unsigned int count) {
  unsigned int index = get_local_id(0) + (32 * get_group_id(0));
  for (unsigned int i = 0; i < 4; i++) {
    if (index < count) {
      _buf0[hook(0, index)] = x_if_odd_else_y(2, _buf0[hook(0, index)]);
      index += 8;
    }
  }
}