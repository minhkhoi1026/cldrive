//{"data_in":0,"data_out":1,"filter_beg":2,"filters":3,"log_threshold":9,"num_banks":7,"num_banks2":8,"pitch":4,"sum":10,"window_count":5,"window_size2":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelFilter(global float* data_in, global float* data_out, constant int* filter_beg, constant float* filters, int pitch, int window_count, int window_size2, int num_banks, int num_banks2, float log_threshold) {
  int frame_index = get_global_id(0), idx_shift = get_global_size(0);

  while (frame_index < window_count) {
    float sum[2] = {0, 0};
    int curf = 0;
    int lastf = filter_beg[hook(2, num_banks + 1)];
    for (int i = filter_beg[hook(2, 0)]; i <= lastf; i++) {
      float v = data_in[hook(0, pitch * i + frame_index)];

      if (i == filter_beg[hook(2, curf + 1)]) {
        curf++;
        if (curf >= 2) {
          int sumidx = curf % 2;
          data_out[hook(1, num_banks2 * frame_index + curf - 2)] = log(max(sum[hook(10, sumidx)], log_threshold));
          sum[hook(10, sumidx)] = 0;
        }
      }
      sum[hook(10, 0)] += filters[hook(3, i)] * v;
      sum[hook(10, 1)] += filters[hook(3, window_size2 + i)] * v;
    }
    frame_index += idx_shift;
  }
}