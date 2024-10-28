//{"height":3,"histogram":0,"img":1,"local_hist":6,"num_hist_bins":5,"pitch":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_histogram_local_memory(global int* histogram, global const float* img, int width, int height, int pitch, int num_hist_bins, local int* local_hist) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int id = get_local_id(0) + get_local_id(1) * get_local_size(0);
  int size = get_local_size(0) * get_local_size(1);

  int value = -1;
  if (x < width && y < height) {
    value = img[hook(1, y * pitch + x)] * num_hist_bins;
    value = min(num_hist_bins - 1, max(0, value));
  }

  for (int i = id; i < num_hist_bins; i = i + size) {
    local_hist[hook(6, i)] = 0;
  }

  barrier(0x01);

  if (value >= 0) {
    atomic_add(&local_hist[hook(6, value)], 1);
  }

  barrier(0x01);

  for (int i = id; i < num_hist_bins; i = i + size) {
    atomic_add(&histogram[hook(0, i)], local_hist[hook(6, i)]);
  }
}