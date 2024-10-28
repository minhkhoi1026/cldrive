//{"data":0,"m":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void upsweep_pow2(local int* x, int m) {
  int lid = get_local_id(0);
  int bi = (lid * 2) + 1;

  int depth = 1 + (int)log2((float)m);
  for (int d = 0; d < depth; d++) {
    barrier(0x01);
    int mask = (0x1 << d) - 1;
    if ((lid & mask) == mask) {
      int offset = (0x1 << d);
      int ai = bi - offset;
      x[hook(1, bi)] += x[hook(1, ai)];
    }
  }
}

inline void sweepdown_pow2(local int* x, int m) {
  int lid = get_local_id(0);
  int bi = (lid * 2) + 1;

  int depth = (int)log2((float)m);
  for (int d = depth; d > -1; d--) {
    barrier(0x01);
    int mask = (0x1 << d) - 1;
    if ((lid & mask) == mask) {
      int offset = (0x1 << d);
      int ai = bi - offset;
      int tmp = x[hook(1, ai)];
      x[hook(1, ai)] = x[hook(1, bi)];
      x[hook(1, bi)] += tmp;
    }
  }
}

inline void scan_pow2(local int* x, int m) {
  int lid = get_local_id(0);
  int lane1 = (lid * 2) + 1;
  upsweep_pow2(x, m);
  if (lane1 == (m - 1)) {
    x[hook(1, lane1)] = 0;
  }
  sweepdown_pow2(x, m);
}
kernel void scan_pow2_wrapper(global int* data, local int* x, int m) {
  int gid = get_global_id(0);
  int lane0 = (gid * 2);
  int lane1 = (gid * 2) + 1;

  x[hook(1, lane0)] = data[hook(0, lane0)];
  x[hook(1, lane1)] = data[hook(0, lane1)];

  scan_pow2(x, m);

  data[hook(0, lane0)] = x[hook(1, lane0)];
  data[hook(0, lane1)] = x[hook(1, lane1)];
}