//{"changed":4,"column_indices":2,"comp":3,"m":0,"row_offsets":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hook(int m, global int* row_offsets, global int* column_indices, global int* comp, global bool* changed) {
  int src = get_global_id(0);
  if (src < m) {
    int comp_src = comp[hook(3, src)];
    int row_begin = row_offsets[hook(1, src)];
    int row_end = row_offsets[hook(1, src + 1)];
    for (int offset = row_begin; offset < row_end; offset++) {
      int dst = column_indices[hook(2, offset)];
      int comp_dst = comp[hook(3, dst)];
      if (comp_src == comp_dst)
        continue;
      int high_comp = comp_src > comp_dst ? comp_src : comp_dst;
      int low_comp = comp_src + (comp_dst - high_comp);
      if (high_comp == comp[hook(3, high_comp)]) {
        *changed = true;
        comp[hook(3, high_comp)] = low_comp;
      }
    }
  }
}