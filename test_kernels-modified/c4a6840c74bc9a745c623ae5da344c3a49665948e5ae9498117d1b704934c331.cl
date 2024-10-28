//{"curDelta":5,"curOutput":2,"curP":0,"nexDelta":4,"nexP":1,"nexWeights":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmoid(const float pNum) {
  return (1.0f / (1.0f + native_exp(-pNum)));
}

kernel void calcLayerDelta(const int curP, const int nexP, global const float* curOutput, global const float* nexWeights, global const float* nexDelta, global float* curDelta) {
  const size_t i = get_global_id(0);
  if (i < curP) {
    curDelta[hook(5, i)] = curOutput[hook(2, i)] * (1 - curOutput[hook(2, i)]);

    float tmpSum = 0;
    for (int j = 0; j < nexP; ++j) {
      const int weightOffset = j * (curP + 1);
      tmpSum += nexWeights[hook(3, i + 1 + weightOffset)] * nexDelta[hook(4, j)];
    }
    curDelta[hook(5, i)] *= tmpSum;
  }
}