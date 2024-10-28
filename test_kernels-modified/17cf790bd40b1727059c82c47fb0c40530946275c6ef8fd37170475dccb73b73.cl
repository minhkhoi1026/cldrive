//{"out":0,"slm":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_slm(global unsigned int* out) {
  const size_t N = 64 * 1024 / sizeof(unsigned int);
  local unsigned int slm[N];
  const size_t base = N * get_group_id(0);
  for (size_t i = 0; i < N; i++) {
    out[hook(0, base + i)] = slm[hook(1, i)];
  }
}