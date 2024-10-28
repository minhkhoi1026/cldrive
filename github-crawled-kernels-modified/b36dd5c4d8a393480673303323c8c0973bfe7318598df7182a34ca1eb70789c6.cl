//{"in":0,"numOfTotal":2,"out":1,"windowSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lowPass(global const float2* in, global float2* out, const unsigned int numOfTotal, const unsigned int windowSize) {
  for (size_t i = 0; i < windowSize - 1; i++)
    out[hook(1, i)] = (float2)0.0f;

  float2 value = (float2)0.0f;
  for (size_t i = 0; i < windowSize; i++)
    value += in[hook(0, i)];

  out[hook(1, windowSize - 1)] = value / (float2)windowSize;
  for (size_t i = windowSize; i < numOfTotal; i++) {
    value += (in[hook(0, i)] - in[hook(0, i - windowSize)]);
    out[hook(1, i)] = value / (float2)windowSize;
  }
}