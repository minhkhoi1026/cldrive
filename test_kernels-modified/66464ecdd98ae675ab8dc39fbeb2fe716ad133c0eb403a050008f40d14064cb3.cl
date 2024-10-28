//{"curInp":3,"curOutput":5,"curP":1,"curWeight":2,"inpOffset":4,"preP":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmoid(const float pNum) {
  return (1.0f / (1.0f + native_exp(-pNum)));
}

kernel void calcLayer(const int preP, const int curP, global const float* curWeight, global const float* curInp, const unsigned int inpOffset, global float* curOutput) {
  const size_t i = get_global_id(0);
  if (i < curP) {
    const int weightOffset = i * (preP + 1);

    curOutput[hook(5, i)] = 1 * curWeight[hook(2, weightOffset)];

    for (int j = 0; j < preP; ++j) {
      curOutput[hook(5, i)] += curInp[hook(3, j + inpOffset)] * curWeight[hook(2, j + 1 + weightOffset)];
    }
    curOutput[hook(5, i)] = sigmoid(curOutput[hook(5, i)]);
  }
}