//{"cols":2,"data":0,"data_offset":4,"mean":1,"window_count":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelSum(global float* data, global float* mean, int cols, int window_count, int data_offset) {
  int rep = ceil((float)window_count / get_global_size(1)), group_id_y = get_group_id(1), frame_index = group_id_y * rep;
  int xIndex = get_global_id(0);
  if (xIndex >= cols)
    return;

  float sum = 0, sum2 = 0;
  float2 minmaxv = (float2)(0x1.fffffep127f, -0x1.fffffep127f);
  for (int r = 0; r < rep && frame_index < window_count; r++, frame_index++) {
    float v = data[hook(0, data_offset + cols * frame_index + xIndex)];
    sum += v;
  }
  mean[hook(1, cols * group_id_y + xIndex)] = sum;
}