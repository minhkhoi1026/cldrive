//{"colid":8,"d_edge_src":3,"d_mask":2,"d_over":4,"d_parents":0,"d_shadow":1,"edge_cnt":6,"iter":5,"mid":10,"rowinfo":11,"rowptr":7,"start":12,"vertex_cnt":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_hooking_cpu(global int* d_parents, global int* d_shadow, global char* d_mask, global int* d_edge_src, global char* d_over, int iter, int edge_cnt, global int* rowptr, global int* colid, int vertex_cnt, int mid, global int* rowinfo, int start) {
  int tid = get_global_id(0);

  int getnumsum = get_global_size(0);

  int startRow = rowinfo[hook(11, start)];
  int endRow = rowinfo[hook(11, start + 1)];
  tid += startRow;

  for (; tid < endRow; tid += getnumsum) {
    if (tid >= vertex_cnt)
      return;
    int start = rowptr[hook(7, tid)];
    int end = rowptr[hook(7, tid + 1)];
    for (int eid = start; eid < end; eid++) {
      if (d_mask[hook(2, eid)])
        continue;
      int src = tid;

      int dest = colid[hook(8, eid)];
      if (d_parents[hook(0, src)] != d_parents[hook(0, dest)]) {
        int min, max;

        if (d_parents[hook(0, src)] > d_parents[hook(0, dest)]) {
          d_shadow[hook(1, tid)] = d_parents[hook(0, dest)];
        } else {
          d_mask[hook(2, eid)] = true;
        }
        *d_over = false;

      } else {
        d_mask[hook(2, eid)] = true;
      }
    }
  }
}