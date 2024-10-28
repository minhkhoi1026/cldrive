//{"activities":0,"ratios":2,"sizes":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
int read_val(read_only image2d_t input, int x, int y) {
  int2 pos = (int2)(x, y);
  uint4 pixel = read_imageui(input, sampler, pos);
  return pixel.s0;
}

kernel void compute_activity_ratios(global int* activities, global int* sizes, global float* ratios) {
  int pos = get_global_id(0);
  float activity = (float)activities[hook(0, pos + 1)];
  float size = (float)sizes[hook(1, pos)];
  float result = 0.0;
  if (size > 0.0) {
    result = activity / size;
  }
  barrier(0x02);
  ratios[hook(2, pos + 1)] = result;
}