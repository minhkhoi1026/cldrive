//{"isums":0,"lmem":2,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float scanLocalMem(float val, local float* lmem, int exclusive) {
  int idx = get_local_id(0);
  lmem[hook(2, idx)] = 0.0f;

  idx += get_local_size(0);
  lmem[hook(2, idx)] = val;
  barrier(0x01);

  float t;
  for (int i = 1; i < get_local_size(0); i *= 2) {
    t = lmem[hook(2, idx - i)];
    barrier(0x01);
    lmem[hook(2, idx)] += t;
    barrier(0x01);
  }
  return lmem[hook(2, idx - exclusive)];
}

kernel void top_scan(global float* isums, const int n, local float* lmem) {
  float val = 0.0f;
  if (get_local_id(0) < n) {
    val = isums[hook(0, get_local_id(0))];
  }

  val = scanLocalMem(val, lmem, 1);

  if (get_local_id(0) < n) {
    isums[hook(0, get_local_id(0))] = val;
  }
}