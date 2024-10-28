//{"height":3,"histogram":0,"img":1,"num_hist_bins":5,"pitch":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_histogram(global int* histogram, global const float* img, int width, int height, int pitch, int num_hist_bins) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < width && y < height) {
    int value = img[hook(1, y * pitch + x)] * num_hist_bins;
    value = min(num_hist_bins - 1, max(0, value));
    atomic_add(&histogram[hook(0, value)], 1);
  }
}