//{"height":3,"histogram":0,"img":1,"num_hist_bins":5,"pitch":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_histogram(global int* histogram, global const float* img, int width, int height, int pitch, int num_hist_bins) {
  int2 GID;
  GID.x = get_global_id(0);
  GID.y = get_global_id(1);

  if (GID.x < width && GID.y < height) {
    float gray = img[hook(1, GID.y * pitch + GID.x)];
    int index = gray * num_hist_bins;
    if (index >= num_hist_bins)
      index = num_hist_bins - 1;
    atomic_inc(&histogram[hook(0, index)]);
  }
}