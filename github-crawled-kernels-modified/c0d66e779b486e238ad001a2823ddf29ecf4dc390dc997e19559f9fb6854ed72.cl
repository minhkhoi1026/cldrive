//{"count":3,"inputA":0,"inputB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_4(global float* inputA, global float* inputB, global float* output, const unsigned int count) {
  float mA = 0;
  float mB = 0;
  for (unsigned int i = 0; i < count; i++) {
    mA += inputA[hook(0, i)];
    mB += inputB[hook(1, i)];
  }
  mA /= count;
  mB /= count;

  float numerator = 0;
  float denominator = 0;
  float denom1 = 0;
  float denom2 = 0;
  float temp = 0;
  for (unsigned int i = 0; i < count; i++) {
    numerator += (inputA[hook(0, i)] - mA) * (inputB[hook(1, i)] - mB);
  }

  for (unsigned int i = 0; i < count; i++) {
    temp = inputA[hook(0, i)] - mA;
    denom1 += pown(temp, 2);
  }
  temp = 0;

  for (unsigned int i = 0; i < count; i++) {
    temp = inputB[hook(1, i)] - mB;
    denom2 += pown(temp, 2);
  }
  temp = 0;

  temp = denom1 * denom2;
  denominator = sqrt(temp);

  float result = numerator / denominator;

  output[hook(2, 4)] = result;
}