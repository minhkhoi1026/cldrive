//{"d_parents":0,"d_shadow":1,"vertex_cnt":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_pointer_jumping(global int* d_parents, global int* d_shadow, int vertex_cnt) {
  int tid = get_global_id(0);

  int getnumsum = get_global_size(0);
  for (; tid < vertex_cnt; tid += getnumsum) {
    if (tid >= vertex_cnt)
      return;

    int parent = d_parents[hook(0, tid)];
    while (d_parents[hook(0, parent)] != parent) {
      parent = d_parents[hook(0, parent)];
    }

    d_shadow[hook(1, tid)] = parent;
  }
}