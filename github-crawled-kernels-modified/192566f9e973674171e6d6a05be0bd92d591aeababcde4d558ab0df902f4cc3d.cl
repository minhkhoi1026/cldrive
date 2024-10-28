//{"curDelta":3,"curP":1,"curWeight":6,"eta":2,"preOffset":5,"preOutput":4,"preP":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmoid(const float pNum) {
  return (1.0f / (1.0f + native_exp(-pNum)));
}

kernel void applyDelta(const int preP, const int curP, const float eta, global const float* curDelta, global const float* preOutput, const unsigned int preOffset, global float* curWeight) {
  const size_t i = get_global_id(0);
  if (i < curP) {
    const int weightOffset = i * (preP + 1);

    curWeight[hook(6, weightOffset)] += eta * 1 * curDelta[hook(3, i)];
    for (int j = 0; j < preP; ++j) {
      curWeight[hook(6, j + 1 + weightOffset)] += eta * preOutput[hook(4, j + preOffset)] * curDelta[hook(3, i)];
    }
  }
}