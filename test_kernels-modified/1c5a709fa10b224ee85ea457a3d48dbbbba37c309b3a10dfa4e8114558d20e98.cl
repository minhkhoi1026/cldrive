//{"in":0,"numOfTotal":2,"out":1,"windowSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lowPass(global const float* in, global float* out, const unsigned int numOfTotal, const unsigned int windowSize) {
  for (size_t i = 0; i < windowSize - 1; i++)
    out[hook(1, i)] = 0.0f;

  float value = 0.0f;
  for (size_t i = 0; i < windowSize; i++)
    value += in[hook(0, i)];

  out[hook(1, windowSize - 1)] = value / windowSize;
  for (size_t i = windowSize; i < numOfTotal; i++) {
    value += (in[hook(0, i)] - in[hook(0, i - windowSize)]);
    out[hook(1, i)] = value / windowSize;
  }
}