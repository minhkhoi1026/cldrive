//{"column_indices":2,"depths":3,"in_idx":6,"in_queue":4,"m":0,"out_idx":7,"out_queue":5,"row_offsets":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bfs_step(int m, global int* row_offsets, global int* column_indices, global int* depths, global int* in_queue, global int* out_queue, global int* in_idx, global int* out_idx) {
  int tid = get_global_id(0);
  int src, flag = 0;
  if (tid < (*in_idx)) {
    src = in_queue[hook(4, tid)];
    flag = 1;
  }
  if (flag) {
    int row_begin = row_offsets[hook(1, src)];
    int row_end = row_offsets[hook(1, src + 1)];
    for (int offset = row_begin; offset < row_end; ++offset) {
      int dst = column_indices[hook(2, offset)];
      if ((depths[hook(3, dst)] == 1000000000) && (atomic_cmpxchg(&depths[hook(3, dst)], 1000000000, depths[hook(3, src)] + 1) == 1000000000)) {
        int idx = atomic_add(out_idx, 1);
        out_queue[hook(5, idx)] = dst;
      }
    }
  }
}