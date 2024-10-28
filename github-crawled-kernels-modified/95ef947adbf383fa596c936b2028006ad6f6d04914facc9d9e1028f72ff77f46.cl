//{"memory_in":0,"memory_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stencil2D(global float const* restrict memory_in, global float* restrict memory_out) {
  for (int i = 1; i < 32 - 1; ++i) {
    for (int j = 0; j < 32; ++j) {
      const float above = memory_in[hook(0, (i - 1) * 32 + j)];
      const float center = memory_in[hook(0, i * 32 + j)];
      const float below = memory_in[hook(0, (i + 1) * 32 + j)];

      const float factor = 0.3333f;
      const float average = factor * (above + center + below);

      memory_out[hook(1, i * 32 + j)] = average;
    }
  }
}