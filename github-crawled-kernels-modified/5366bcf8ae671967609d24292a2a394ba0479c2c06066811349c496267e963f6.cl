//{"in":0,"offset":3,"out":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan(const global unsigned int* in, global unsigned int* out, unsigned int size, unsigned int offset) {
  unsigned int idx_right = get_global_id(0);
  if (idx_right < size) {
    unsigned int right = in[hook(0, idx_right)];
    unsigned int left = 0;
    if (idx_right >= offset) {
      unsigned int idx_left = idx_right - offset;
      left = in[hook(0, idx_left)];
    }
    out[hook(1, idx_right)] = left + right;
  }
}