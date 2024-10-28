//{"bitmap":7,"colid":1,"float3":4,"over":5,"randlist":2,"rownum":6,"rowptr":0,"vplist":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_ve_slm_pm_fs(global int* rowptr, global int* colid, global int* randlist, global int* vplist, int float3, global char* over, int rownum, global unsigned long* bitmap) {
  int tid = get_global_id(0);
  int getnumsum = get_global_size(0);

  for (; tid < rownum; tid += getnumsum) {
    if (vplist[hook(3, tid)] != 0xffffff00)
      continue;
    if (!(bitmap[hook(7, tid >> 6)] & (1ul << (tid & 0x3f))))
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
    if (found_larger == 0) {
      vplist[hook(3, vid)] = float3;

    } else {
      *over = 0;
    }
  }
}