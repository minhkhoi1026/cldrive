//{"column_indices":2,"dists":4,"in_idx":7,"in_queue":5,"m":0,"out_idx":8,"out_queue":6,"row_offsets":1,"weight":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sssp_step(int m, global int* row_offsets, global int* column_indices, global unsigned* weight, global int* dists, global int* in_queue, global int* out_queue, global int* in_idx, global int* out_idx) {
  int tid = get_global_id(0);
  int src, flag = 0;
  if (tid < (*in_idx)) {
    src = in_queue[hook(5, tid)];
    flag = 1;
  }
  if (flag) {
    int row_begin = row_offsets[hook(1, src)];
    int row_end = row_offsets[hook(1, src + 1)];
    for (int offset = row_begin; offset < row_end; ++offset) {
      int dst = column_indices[hook(2, offset)];
      int old_dist = dists[hook(4, dst)];
      int new_dist = dists[hook(4, src)] + weight[hook(3, offset)];
      if (new_dist < old_dist) {
        if (atomic_min(&dists[hook(4, dst)], new_dist) > new_dist) {
          int idx = atomic_add(out_idx, 1);
          out_queue[hook(6, idx)] = dst;
        }
      }
    }
  }
}