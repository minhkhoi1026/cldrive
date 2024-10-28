//{"histogram":2,"num_groups":1,"partial_histogram":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t format = 0 | 0x10 | 4;
float luminosity_from_color(const float4 col) {
  return 0.21f * col.x + 0.72f * col.y + 0.07f * col.z;
}

kernel void histogram_reduce(global const unsigned int* partial_histogram, const int num_groups, global unsigned int* histogram) {
  int tid = (int)get_global_id(0);
  int group_indx;
  int n = num_groups;

  int tid_histogram = 0;

  for (int i = 0; i < num_groups * 256; i += 256)
    tid_histogram += partial_histogram[hook(0, i + tid)];

  histogram[hook(2, tid)] = tid_histogram;
}