//{"data":1,"shift":6,"tmp":0,"win":7,"window":2,"window_count":3,"window_size":4,"window_size2":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelSegmentWindow(global short* tmp, global float* data, global float* window, int window_count, int window_size, int window_size2, int shift, local float* win) {
  int win_index = get_global_id(0), frame_index = get_local_size(1) * get_group_id(1), idx_shift = get_global_size(1);

  win[hook(7, get_local_id(0))] = window[hook(2, win_index)];
  barrier(0x01);

  while (frame_index < window_count) {
    if (win_index < window_size) {
      int indexIn = frame_index * shift + win_index;
      data[hook(1, window_size2 * frame_index + win_index)] = tmp[hook(0, indexIn)] * win[hook(7, get_local_id(0))];
    } else
      data[hook(1, window_size2 * frame_index + win_index)] = 0;

    frame_index += idx_shift;
  }
}