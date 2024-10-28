//{"I":0,"LI":2,"O":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2D_local_async(global float* I, global float* O) {
  const int nx = get_global_size(0) + 2;
  local float LI[18 * 18 * 2];
  int iL0 = 0;
  int iL1 = 18 * 18;
  event_t event = 0;
  int ig0 = get_group_id(0) * get_local_size(0);
  {
    int ig_ = ig0;
    int il_ = 0;
    for (int i = 0; i < 18; i++) {
      event = async_work_group_copy(LI + il_, I + ig_, 18, event);
      ig_ += nx;
      il_ += 18;
    }
  };
  for (int it = 0; it < 16; it++) {
    int ig = ig0 + (get_local_id(1) + 1) * nx + get_local_id(0) + 1;
    int il = (get_local_id(1) + 1) * 18 + get_local_id(0) + iL0;
    ig0 += get_local_size(1) * nx;
    event_t event_ = 0;
    {
      int ig_ = ig0;
      int il_ = 0;
      for (int i = 0; i < 18; i++) {
        event_ = async_work_group_copy(LI + iL1 + il_, I + ig_, 18, event_);
        ig_ += nx;
        il_ += 18;
      }
    };
    wait_group_events(1, &event);

    O[hook(1, ig)] = (LI[hook(2, il - 18)] + LI[hook(2, il - 18 + 1)] + LI[hook(2, il - 18 + 2)] + LI[hook(2, il)] + LI[hook(2, il + 1)] + LI[hook(2, il + 2)] + LI[hook(2, il + 18)] + LI[hook(2, il + 18 + 1)] + LI[hook(2, il + 18 + 2)]) * 0.11111111111;
    int iLtmp = iL0;
    iL0 = iL1;
    iL1 = iLtmp;
    event = event_;
  }
}