//{"cols":2,"data":0,"data_offset":4,"mean":1,"smean":5,"window_count":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelNormalize(global float* data, global float* mean, int cols, int window_count, int data_offset, local float* smean) {
  int xIndex = get_global_id(0), frame_index = get_global_id(1), idx_shift = get_global_size(1);
  if (xIndex >= cols)
    return;

  if (get_local_id(1) == 0) {
    float m = mean[hook(1, xIndex)];
    smean[hook(5, get_local_id(0))] = m;
  }
  barrier(0x01);

  while (frame_index < window_count) {
    int idx = data_offset + cols * frame_index + xIndex;
    float v = data[hook(0, idx)];

    data[hook(0, idx)] = v - smean[hook(5, get_local_id(0))];

    frame_index += idx_shift;
  }
}