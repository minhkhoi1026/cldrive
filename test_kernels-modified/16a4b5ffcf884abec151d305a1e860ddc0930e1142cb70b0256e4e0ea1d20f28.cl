//{"histogram":2,"num_pixels":1,"pipe_in":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 2;
kernel void consumer(global float* pipe_in, int num_pixels, global int* histogram) {
  int pi;
  float pixel;

  for (pi = 0; pi < num_pixels; pi++) {
    pixel = pipe_in[hook(0, pi)];

    histogram[hook(2, (int)pixel)]++;
  }
}