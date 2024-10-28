//{"idx":6,"num_warps":0,"rows":4,"temp_rows":1,"temp_vals":2,"val":7,"vals":5,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float s_segreduce_warp(const int thread_lane, int row, float val, local int* rows, local float* vals) {
  int tid = get_local_id(0);

  rows[hook(4, tid)] = row;
  vals[hook(5, tid)] = val;

  if (thread_lane >= 1 && row == rows[hook(4, tid - 1)]) {
    vals[hook(5, tid)] = val = val + vals[hook(5, tid - 1)];
  }
  if (thread_lane >= 2 && row == rows[hook(4, tid - 2)]) {
    vals[hook(5, tid)] = val = val + vals[hook(5, tid - 2)];
  }
  if (thread_lane >= 4 && row == rows[hook(4, tid - 4)]) {
    vals[hook(5, tid)] = val = val + vals[hook(5, tid - 4)];
  }
  if (thread_lane >= 8 && row == rows[hook(4, tid - 8)]) {
    vals[hook(5, tid)] = val = val + vals[hook(5, tid - 8)];
  }
  if (thread_lane >= 16 && row == rows[hook(4, tid - 16)]) {
    vals[hook(5, tid)] = val = val + vals[hook(5, tid - 16)];
  }

  return val;
}
inline void s_segreduce_block(local const int* idx, local float* val) {
  float left = 0;
  int tid = get_local_id(0);

  if (tid >= 1 && idx[hook(6, tid)] == idx[hook(6, tid - 1)]) {
    left = val[hook(7, tid - 1)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 2 && idx[hook(6, tid)] == idx[hook(6, tid - 2)]) {
    left = val[hook(7, tid - 2)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 4 && idx[hook(6, tid)] == idx[hook(6, tid - 4)]) {
    left = val[hook(7, tid - 4)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 8 && idx[hook(6, tid)] == idx[hook(6, tid - 8)]) {
    left = val[hook(7, tid - 8)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 16 && idx[hook(6, tid)] == idx[hook(6, tid - 16)]) {
    left = val[hook(7, tid - 16)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 32 && idx[hook(6, tid)] == idx[hook(6, tid - 32)]) {
    left = val[hook(7, tid - 32)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 64 && idx[hook(6, tid)] == idx[hook(6, tid - 64)]) {
    left = val[hook(7, tid - 64)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 128 && idx[hook(6, tid)] == idx[hook(6, tid - 128)]) {
    left = val[hook(7, tid - 128)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 256 && idx[hook(6, tid)] == idx[hook(6, tid - 256)]) {
    left = val[hook(7, tid - 256)];
  }
  barrier(0x01);
  val[hook(7, tid)] += left;
  left = 0;
  barrier(0x01);
}
kernel void s_kernel_coo_spmv_reduce_update(const int num_warps, global const int* temp_rows, global const float* temp_vals, global float* y) {
  local int rows[256 + 1];
  local float vals[256 + 1];

  int tid = get_local_id(0);

  const int end = num_warps - (num_warps & (256 - 1));

  if (tid == 0) {
    rows[hook(4, 256)] = (int)-1;
    vals[hook(5, 256)] = (float)0.0;
  }

  barrier(0x01);

  int i = tid;

  while (i < end) {
    rows[hook(4, tid)] = temp_rows[hook(1, i)];
    vals[hook(5, tid)] = temp_vals[hook(2, i)];

    barrier(0x01);

    s_segreduce_block(rows, vals);

    if (rows[hook(4, tid)] != rows[hook(4, tid + 1)])
      y[hook(3, rows[thook(4, tid))] += vals[hook(5, tid)];

    barrier(0x01);

    i += 256;
  }

  if (end < num_warps) {
    if (i < num_warps) {
      rows[hook(4, tid)] = temp_rows[hook(1, i)];
      vals[hook(5, tid)] = temp_vals[hook(2, i)];
    } else {
      rows[hook(4, tid)] = (int)-1;
      vals[hook(5, tid)] = (float)0.0;
    }

    barrier(0x01);

    s_segreduce_block(rows, vals);

    if (i < num_warps)
      if (rows[hook(4, tid)] != rows[hook(4, tid + 1)])
        y[hook(3, rows[thook(4, tid))] += vals[hook(5, tid)];
  }
}