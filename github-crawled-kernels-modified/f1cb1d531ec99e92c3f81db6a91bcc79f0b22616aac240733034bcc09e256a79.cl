//{"in":0,"out":1,"windowSize":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lowPass(global const float* in, global float* out, const unsigned int windowSize) {
  unsigned int x = get_global_id(0);

  float value = 0.0f;
  for (unsigned int i = x; i < x + windowSize; i++)
    value += in[hook(0, i)];

  out[hook(1, x + windowSize - 1)] = value / windowSize;
}