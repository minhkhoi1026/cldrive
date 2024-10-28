//{"_buf0":0,"_buf1":1,"count":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline ulong boost_popcount(const ulong x) {
  ulong count = 0;
  for (ulong i = 0; i < sizeof(i) * 8; i++) {
    if (x & (ulong)1 << i) {
      count++;
    }
  }
  return count;
}

kernel void copy(global int* _buf0, global ulong* _buf1, const unsigned int count) {
  unsigned int index = get_local_id(0) + (32 * get_group_id(0));
  for (unsigned int i = 0; i < 4; i++) {
    if (index < count) {
      _buf0[hook(0, index)] = boost_popcount(_buf1[hook(1, index)]);
      index += 8;
    }
  }
}