//{"column_indices":2,"deltas":9,"depth":8,"depths":7,"num":0,"path_counts":6,"queue":4,"row_offsets":1,"scores":5,"start":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bc_reverse(int num, global int* row_offsets, global int* column_indices, int start, global int* queue, global float* scores, global int* path_counts, global int* depths, int depth, global float* deltas) {
  int tid = get_global_id(0);
  int src;
  if (tid < num) {
    int src = queue[hook(4, start + tid)];
    int row_begin = row_offsets[hook(1, src)];
    int row_end = row_offsets[hook(1, src + 1)];
    for (int offset = row_begin; offset < row_end; ++offset) {
      int dst = column_indices[hook(2, offset)];
      if (depths[hook(7, dst)] == depth + 1) {
        deltas[hook(9, src)] += (1.0 + deltas[hook(9, dst)]) * path_counts[hook(6, src)] / path_counts[hook(6, dst)];
      }
    }
    scores[hook(5, src)] += deltas[hook(9, src)];
  }
}