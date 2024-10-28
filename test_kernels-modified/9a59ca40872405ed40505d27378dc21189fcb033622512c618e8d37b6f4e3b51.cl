//{"init_val":0,"slm":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_slm(global unsigned int* init_val) {
  const size_t N = (64 * 1024) / sizeof(unsigned int);
  local unsigned int slm[N];
  unsigned int sublice_header = (get_group_id(0) + 1) << (6 * 4);
  unsigned int tmp = *init_val;
  for (int i = 0; i < N; i++) {
    slm[hook(1, i)] = sublice_header | tmp;
    tmp = (tmp >= 0xf000) ? 0x0 : tmp + 1;
  }
}