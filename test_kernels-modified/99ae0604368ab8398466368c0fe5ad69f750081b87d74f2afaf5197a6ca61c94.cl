//{"data":0,"data2":3,"f":8,"flag":2,"flag2":5,"n":9,"p":7,"part":1,"part2":4,"x":6}
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
      if (!p[hook(7, bi)]) {
        x[hook(6, bi)] += x[hook(6, ai)];
      }
      p[hook(7, bi)] = p[hook(7, bi)] | p[hook(7, ai)];
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
      int tmp = x[hook(6, ai)];
      x[hook(6, ai)] = x[hook(6, bi)];
      if (f[hook(8, ai + 1)]) {
        x[hook(6, bi)] = 0;
      } else if (p[hook(7, ai)]) {
        x[hook(6, bi)] = tmp;
      } else {
        x[hook(6, bi)] += tmp;
      }
      p[hook(7, ai)] = 0;
    }
  }
}

inline void scan_pow2(local int* x, local int* p, local int* f, int m) {
  int lid = get_local_id(0);
  int lane1 = (lid * 2) + 1;
  upsweep_pow2(x, p, m);
  if (lane1 == (m - 1)) {
    x[hook(6, lane1)] = 0;
  }
  sweepdown_pow2(x, p, f, m);
}
kernel void upsweep_subarrays(global int* data, global int* part, global int* flag, global int* data2, global int* part2, global int* flag2, local int* x, local int* p, local int* f, int n) {
  int wx = get_local_size(0);

  int gid = get_global_id(0);
  int lane0 = (2 * gid);
  int lane1 = (2 * gid) + 1;

  int lid = get_local_id(0);
  int local_lane0 = (2 * lid);
  int local_lane1 = (2 * lid) + 1;
  int grpid = get_group_id(0);

  int m = wx * 2;
  int k = get_num_groups(0);

  x[hook(6, local_lane0)] = (lane0 < n) ? data[hook(0, lane0)] : 0;
  x[hook(6, local_lane1)] = (lane1 < n) ? data[hook(0, lane1)] : 0;
  p[hook(7, local_lane0)] = (lane0 < n) ? part[hook(1, lane0)] : 0;
  p[hook(7, local_lane1)] = (lane1 < n) ? part[hook(1, lane1)] : 0;
  f[hook(8, local_lane0)] = (lane0 < n) ? flag[hook(2, lane0)] : 0;
  f[hook(8, local_lane1)] = (lane1 < n) ? flag[hook(2, lane1)] : 0;

  upsweep_pow2(x, p, m);

  if (lid == (wx - 1)) {
    data2[hook(3, grpid)] = x[hook(6, local_lane1)];
    part2[hook(4, grpid)] = p[hook(7, local_lane1)];
  }

  if (lid == 0) {
    flag2[hook(5, grpid)] = f[hook(8, local_lane0)];
  }

  data[hook(0, lane0)] = x[hook(6, local_lane0)];
  data[hook(0, lane1)] = x[hook(6, local_lane1)];
  part[hook(1, lane0)] = p[hook(7, local_lane0)];
  part[hook(1, lane1)] = p[hook(7, local_lane1)];
}