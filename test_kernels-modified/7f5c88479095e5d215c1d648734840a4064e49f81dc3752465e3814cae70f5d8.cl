//{"I":2,"L":4,"O":3,"nx":0,"ny":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2D_scanline_async(int nx, int ny, global float* I, global float* O) {
  local float L[66 * 4];
  int i0 = 0;
  int i1 = 66;
  int i2 = 66 * 2;
  int i3 = 66 * 3;
  event_t event = 0;
  int ig0 = get_group_id(0) * get_local_size(0);
  event = async_work_group_copy(L, I + ig0, 66, event);
  ig0 += nx;
  event = async_work_group_copy(L + 66, I + ig0, 66, event);
  ig0 += nx;
  event = async_work_group_copy(L + 66 * 2, I + ig0, 66, event);
  ig0 += nx;
  const int il = get_local_id(0);
  int ig = get_global_id(0) + 1;
  for (int iy = 1; iy < (ny - 2); iy++) {
    wait_group_events(1, &event);
    event = async_work_group_copy(L + i3, I + ig0, 66, event);
    ig0 += nx;
    ig += nx;
    O[hook(3, ig)] = (L[hook(4, i0 + il)] + L[hook(4, i0 + il + 1)] + L[hook(4, i0 + il + 2)] + L[hook(4, i1 + il)] + L[hook(4, i1 + il + 1)] + L[hook(4, i1 + il + 2)] + L[hook(4, i2 + il)] + L[hook(4, i2 + il + 1)] + L[hook(4, i2 + il + 2)]) * 0.11111111111;
    local float* Ltmp;
    int itmp = i0;
    i0 = i1;
    i1 = i2;
    i2 = i3;
    i3 = itmp;
  }
}