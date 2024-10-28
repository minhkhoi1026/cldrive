//{"memory_in":0,"memory_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Simple1DStencil(global float const* restrict memory_in, global float* restrict memory_out) {
  for (int i = 1; i < 1024 - 1; ++i) {
    float left = memory_in[hook(0, i - 1)];
    float center = memory_in[hook(0, i)];
    float right = memory_in[hook(0, i + 1)];

    const float factor = 0.3333f;
    float average = factor * (left + center + right);

    memory_out[hook(1, i)] = average;
  }
}