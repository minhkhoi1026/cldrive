//{"outDelta":4,"outOutput":1,"outP":0,"target":2,"targetOffset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmoid(const float pNum) {
  return (1.0f / (1.0f + native_exp(-pNum)));
}

kernel void calcOutputDelta(const int outP, global const float* outOutput, global const float* target, const unsigned int targetOffset, global float* outDelta) {
  const size_t i = get_global_id(0);
  if (i < outP) {
    outDelta[hook(4, i)] = outOutput[hook(1, i)] * (1 - outOutput[hook(1, i)]) * (target[hook(2, i + targetOffset)] - outOutput[hook(1, i)]);
  }
}