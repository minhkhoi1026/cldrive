//{"buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test0(global char* buffer) {
  unsigned int tid = get_global_id(0) % 256;
  unsigned int wave = get_global_id(0) >> 8;
  ulong data = get_global_id(0) << 16;
  unsigned int block;
  unsigned int rep = 128;

  while (rep--) {
    global ulong* p = (global ulong*)(buffer + wave * (1024 * 1024 * 1024 / 32));
    for (block = 0; block < ((1024 * 1024 * 1024 / sizeof(ulong)) / 32); block += 256) {
      *(p + block + tid) = data;
    }
  }
}