//{"colid":1,"float3":4,"mid":7,"over":5,"randlist":2,"rowinfo":8,"rownum":6,"rowptr":0,"start":9,"vplist":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_ve_slm_pm_fs(global int* rowptr, global int* colid, global int* randlist, global int* vplist, int float3, global char* over, int rownum, int mid, global int* rowinfo, int start) {
  int tid = get_global_id(0);
  int getnumsum = get_global_size(0);

  int startRow = rowinfo[hook(8, start)];
  int endRow = rowinfo[hook(8, start + 1)];
  tid += startRow;

  for (; tid < endRow; tid += getnumsum) {
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
    if (found_larger == 0) {
      vplist[hook(3, vid)] = float3;

    } else {
      *over = 0;
    }
  }
}