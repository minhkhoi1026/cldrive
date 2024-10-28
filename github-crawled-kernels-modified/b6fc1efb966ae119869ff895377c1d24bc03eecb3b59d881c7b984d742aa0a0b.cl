//{"luminosity":0,"partial_histogram":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t format = 0 | 0x10 | 4;
float luminosity_from_color(const float4 col) {
  return 0.21f * col.x + 0.72f * col.y + 0.07f * col.z;
}

kernel void histogram_partial(global const uchar* luminosity, global unsigned int* partial_histogram) {
  int image_len = get_global_size(0) * get_global_size(1);
  int group_indx = get_global_id(1) * 256;
  int linear_index = get_global_id(1) * get_global_size(0) + get_global_id(0);

  if (linear_index < image_len) {
    uchar col_indx = luminosity[hook(0, linear_index)];
    atomic_inc(&partial_histogram[hook(1, group_indx + col_indx)]);
  }
}