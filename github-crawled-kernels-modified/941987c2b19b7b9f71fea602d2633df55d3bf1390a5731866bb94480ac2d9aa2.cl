//{"partial_histogram":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t format = 0 | 0x10 | 4;
float luminosity_from_color(const float4 col) {
  return 0.21f * col.x + 0.72f * col.y + 0.07f * col.z;
}

kernel void histogram_init(global unsigned int* partial_histogram) {
  int group_indx = get_global_id(1) * 256;
  int tid = get_global_id(0);
  if (tid < 256)
    partial_histogram[hook(0, group_indx + tid)] = 0;
}