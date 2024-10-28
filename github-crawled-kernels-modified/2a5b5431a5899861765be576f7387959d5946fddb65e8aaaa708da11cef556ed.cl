//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dragon(global unsigned int* out) {
  size_t tid = get_global_id(0);

  int n = tid * sizeof(unsigned int) * 8;

  size_t left = 0;
  for (size_t i = 0, end = sizeof(unsigned int) * 8; i != end; ++i) {
    ++n;
    left = left << 1;
    left |= ((((n & -n) << 1) & n) != 0) & 1;
  }
  out[hook(0, tid)] = left;
}