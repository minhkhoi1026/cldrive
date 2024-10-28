//{"column_indices":1,"depth":4,"depths":3,"in_idx":7,"in_queue":5,"out_idx":8,"out_queue":6,"path_counts":2,"row_offsets":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bc_forward(global int* row_offsets, global int* column_indices, global int* path_counts, global int* depths, int depth, global int* in_queue, global int* out_queue, global int* in_idx, global int* out_idx) {
  int tid = get_global_id(0);
  int src, flag = 0;
  if (tid < (*in_idx)) {
    src = in_queue[hook(5, tid)];
    flag = 1;
  }
  if (flag) {
    int row_begin = row_offsets[hook(0, src)];
    int row_end = row_offsets[hook(0, src + 1)];
    for (int offset = row_begin; offset < row_end; ++offset) {
      int dst = column_indices[hook(1, offset)];
      if ((depths[hook(3, dst)] == -1) && (atomic_cmpxchg(&depths[hook(3, dst)], -1, depth)) == -1) {
        int index = atomic_add(out_idx, 1);
        out_queue[hook(6, index)] = dst;
      }

      if (depths[hook(3, dst)] == depth) {
        atomic_add(&path_counts[hook(2, dst)], path_counts[hook(2, src)]);
      }
    }
  }
}