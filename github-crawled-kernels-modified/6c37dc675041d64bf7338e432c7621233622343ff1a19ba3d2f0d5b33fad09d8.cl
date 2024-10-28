//{"idx":8,"in_col":2,"in_row":1,"nnz":0,"out_col":5,"out_row":4,"perm":3,"rows":6,"val":9,"vals":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float s_segreduce_warp(const int thread_lane, int row, float val, local int* rows, local float* vals) {
  int tid = get_local_id(0);

  rows[hook(6, tid)] = row;
  vals[hook(7, tid)] = val;

  if (thread_lane >= 1 && row == rows[hook(6, tid - 1)]) {
    vals[hook(7, tid)] = val = val + vals[hook(7, tid - 1)];
  }
  if (thread_lane >= 2 && row == rows[hook(6, tid - 2)]) {
    vals[hook(7, tid)] = val = val + vals[hook(7, tid - 2)];
  }
  if (thread_lane >= 4 && row == rows[hook(6, tid - 4)]) {
    vals[hook(7, tid)] = val = val + vals[hook(7, tid - 4)];
  }
  if (thread_lane >= 8 && row == rows[hook(6, tid - 8)]) {
    vals[hook(7, tid)] = val = val + vals[hook(7, tid - 8)];
  }
  if (thread_lane >= 16 && row == rows[hook(6, tid - 16)]) {
    vals[hook(7, tid)] = val = val + vals[hook(7, tid - 16)];
  }

  return val;
}
inline void s_segreduce_block(local const int* idx, local float* val) {
  float left = 0;
  int tid = get_local_id(0);

  if (tid >= 1 && idx[hook(8, tid)] == idx[hook(8, tid - 1)]) {
    left = val[hook(9, tid - 1)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 2 && idx[hook(8, tid)] == idx[hook(8, tid - 2)]) {
    left = val[hook(9, tid - 2)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 4 && idx[hook(8, tid)] == idx[hook(8, tid - 4)]) {
    left = val[hook(9, tid - 4)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 8 && idx[hook(8, tid)] == idx[hook(8, tid - 8)]) {
    left = val[hook(9, tid - 8)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 16 && idx[hook(8, tid)] == idx[hook(8, tid - 16)]) {
    left = val[hook(9, tid - 16)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 32 && idx[hook(8, tid)] == idx[hook(8, tid - 32)]) {
    left = val[hook(9, tid - 32)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 64 && idx[hook(8, tid)] == idx[hook(8, tid - 64)]) {
    left = val[hook(9, tid - 64)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 128 && idx[hook(8, tid)] == idx[hook(8, tid - 128)]) {
    left = val[hook(9, tid - 128)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
  if (tid >= 256 && idx[hook(8, tid)] == idx[hook(8, tid - 256)]) {
    left = val[hook(9, tid - 256)];
  }
  barrier(0x01);
  val[hook(9, tid)] += left;
  left = 0;
  barrier(0x01);
}
kernel void d_kernel_coo_permute(const int nnz, global const int* in_row, global const int* in_col, global const int* perm, global int* out_row, global int* out_col) {
  int ind = get_global_id(0);

  for (int i = ind; i < nnz; i += get_local_size(0)) {
    out_row[hook(4, i)] = perm[hook(3, in_row[ihook(1, i))];
    out_col[hook(5, i)] = perm[hook(3, in_col[ihook(2, i))];
  }
}