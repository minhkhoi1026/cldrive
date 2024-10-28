//{"data":0,"f":5,"flag":2,"n":6,"p":4,"part":1,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void upsweep_pow2(local int* x, local int* p, int m) {
  int lid = get_local_id(0);
  int bi = (lid * 2) + 1;

  int depth = 1 + (int)log2((float)m);
  for (int d = 0; d < depth; d++) {
    barrier(0x01);
    int mask = (0x1 << d) - 1;
    if ((lid & mask) == mask) {
      int offset = (0x1 << d);
      int ai = bi - offset;
      if (!p[hook(4, bi)]) {
        x[hook(3, bi)] += x[hook(3, ai)];
      }
      p[hook(4, bi)] = p[hook(4, bi)] | p[hook(4, ai)];
    }
  }
}

inline void sweepdown_pow2(local int* x, local int* p, local int* f, int m) {
  int lid = get_local_id(0);
  int bi = (lid * 2) + 1;

  int depth = (int)log2((float)m);
  for (int d = depth; d > -1; d--) {
    barrier(0x01);
    int mask = (0x1 << d) - 1;
    if ((lid & mask) == mask) {
      int offset = (0x1 << d);
      int ai = bi - offset;
      int tmp = x[hook(3, ai)];
      x[hook(3, ai)] = x[hook(3, bi)];
      if (f[hook(5, ai + 1)]) {
        x[hook(3, bi)] = 0;
      } else if (p[hook(4, ai)]) {
        x[hook(3, bi)] = tmp;
      } else {
        x[hook(3, bi)] += tmp;
      }
      p[hook(4, ai)] = 0;
    }
  }
}

inline void scan_pow2(local int* x, local int* p, local int* f, int m) {
  int lid = get_local_id(0);
  int lane1 = (lid * 2) + 1;
  upsweep_pow2(x, p, m);
  if (lane1 == (m - 1)) {
    x[hook(3, lane1)] = 0;
  }
  sweepdown_pow2(x, p, f, m);
}
kernel void segscan_pad_to_pow2(global int* data, global int* part, global int* flag, local int* x, local int* p, local int* f, int n) {
  int gid = get_global_id(0);
  int lane0 = (gid * 2);
  int lane1 = (gid * 2) + 1;
  int m = 2 * get_local_size(0);

  x[hook(3, lane0)] = lane0 < n ? data[hook(0, lane0)] : 0;
  x[hook(3, lane1)] = lane1 < n ? data[hook(0, lane1)] : 0;
  p[hook(4, lane0)] = lane0 < n ? part[hook(1, lane0)] : 0;
  p[hook(4, lane1)] = lane1 < n ? part[hook(1, lane1)] : 0;
  f[hook(5, lane0)] = lane0 < n ? flag[hook(2, lane0)] : 0;
  f[hook(5, lane1)] = lane1 < n ? flag[hook(2, lane1)] : 0;

  scan_pow2(x, p, f, m);

  if (lane0 < n)
    data[hook(0, lane0)] = x[hook(3, lane0)];
  if (lane1 < n)
    data[hook(0, lane1)] = x[hook(3, lane1)];
}