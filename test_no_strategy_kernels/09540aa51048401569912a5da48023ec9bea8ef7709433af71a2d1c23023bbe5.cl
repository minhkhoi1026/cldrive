//{"isums":0,"lmem":2,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void top_scan(global unsigned int* isums, const int n, local unsigned int* lmem) {
  local int s_seed;
  s_seed = 0;
  barrier(0x01);

  int last_thread = (get_local_id(0) < n && (get_local_id(0) + 1) == n) ? 1 : 0;

  for (int d = 0; d < 16; d++) {
    int idx = get_local_id(0);
    lmem[hook(2, idx)] = 0;
    if (last_thread) {
      s_seed += 42;
    }
    barrier(0x01);
  }
}