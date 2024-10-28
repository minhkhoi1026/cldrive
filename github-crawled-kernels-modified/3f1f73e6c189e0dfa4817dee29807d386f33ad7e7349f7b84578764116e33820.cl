//{"colid":1,"float3":4,"mid":7,"over":5,"randlist":2,"rownum":6,"rowptr":0,"vplist":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_csr(global int* rowptr, global int* colid, global int* randlist, global int* vplist, int float3, global int* over, int rownum, int mid) {
  int tid = get_global_id(0);
  tid += mid;
  int getnumsum = get_global_size(0);

  for (; tid < rownum; tid += getnumsum) {
    if (vplist[hook(3, tid)] != 0xffffff00)
      continue;
    int vid = tid;
    int start = rowptr[hook(0, vid)];
    int end = rowptr[hook(0, vid + 1)];
    int local_rand = randlist[hook(2, vid)];
    char found_larger = 0;
    for (int i = start; i < end; i++) {
      int dest = colid[hook(1, i)];

      if ((vplist[hook(3, dest)] < float3) && vplist[hook(3, dest)] >= 0)
        continue;
      if ((randlist[hook(2, dest)] > local_rand) || ((randlist[hook(2, dest)] == local_rand) && (dest < vid))) {
        found_larger = 1;
        break;
      }
    }
    if (found_larger == 0)
      vplist[hook(3, vid)] = float3;
    else
      *over = 0;
  }
}