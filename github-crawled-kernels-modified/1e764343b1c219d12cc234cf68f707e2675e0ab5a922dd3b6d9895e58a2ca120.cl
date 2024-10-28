//{"height":3,"histogram":0,"img":1,"local_hist":6,"num_hist_bins":5,"pitch":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_histogram_local_memory(global int* histogram, global const float* img, int width, int height, int pitch, int num_hist_bins, local int* local_hist) {
  int2 GID, LID;
  GID.x = get_global_id(0);
  GID.y = get_global_id(1);
  LID.x = get_local_id(0);
  LID.y = get_local_id(1);
  if (LID.x == 0 && LID.y == 0) {
    for (int i = 0; i < num_hist_bins; i++)
      local_hist[hook(6, i)] = 0;
  }
  barrier(0x01);

  if (GID.x < width && GID.y < height) {
    float gray = img[hook(1, GID.y * pitch + GID.x)];
    int index = gray * num_hist_bins;
    if (index >= 64)
      index = 63;
    atomic_inc(&local_hist[hook(6, index)]);
  }
  barrier(0x01);

  if (LID.x == 0 && LID.y == 0) {
    for (int i = 0; i < num_hist_bins; i++)
      atomic_add(&histogram[hook(0, i)], local_hist[hook(6, i)]);
  }
}