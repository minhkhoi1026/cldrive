//{"base":6,"batch":2,"input":3,"localInput":7,"n":0,"offset":1,"output":5,"temp":4,"x":8,"xOut":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

void softmax_device_optimized(global float* x, global float* xOut) {
  int i = 0;
  float8 tempValue = (float8)0.0f;
  float8 localInput[10];
  localInput[hook(7, 0)] = vload8(0, &x[hook(8, 0)]);
  localInput[hook(7, 1)] = vload8(0, &x[hook(8, 8)]);
  localInput[hook(7, 2)] = vload8(0, &x[hook(8, 16)]);
  localInput[hook(7, 3)] = vload8(0, &x[hook(8, 24)]);
  localInput[hook(7, 4)] = vload8(0, &x[hook(8, 32)]);
  localInput[hook(7, 5)] = vload8(0, &x[hook(8, 40)]);
  localInput[hook(7, 6)] = vload8(0, &x[hook(8, 48)]);
  localInput[hook(7, 7)] = vload8(0, &x[hook(8, 56)]);
  localInput[hook(7, 8)] = vload8(0, &x[hook(8, 64)]);
  localInput[hook(7, 9)] = vload8(0, &x[hook(8, 72)]);

  float8 maxValue;
  float largest = 0;

  maxValue = max(localInput[hook(7, 0)], localInput[hook(7, 1)]);
  maxValue = max(maxValue, localInput[hook(7, 2)]);
  maxValue = max(maxValue, localInput[hook(7, 3)]);
  maxValue = max(maxValue, localInput[hook(7, 4)]);
  maxValue = max(maxValue, localInput[hook(7, 5)]);
  maxValue = max(maxValue, localInput[hook(7, 6)]);
  maxValue = max(maxValue, localInput[hook(7, 7)]);
  maxValue = max(maxValue, localInput[hook(7, 8)]);
  maxValue = max(maxValue, localInput[hook(7, 9)]);
  maxValue = max(maxValue, localInput[hook(7, 10)]);

  largest = (maxValue.s0 > largest) ? maxValue.s0 : largest;
  largest = (maxValue.s1 > largest) ? maxValue.s1 : largest;
  largest = (maxValue.s2 > largest) ? maxValue.s2 : largest;
  largest = (maxValue.s3 > largest) ? maxValue.s3 : largest;
  largest = (maxValue.s4 > largest) ? maxValue.s4 : largest;
  largest = (maxValue.s5 > largest) ? maxValue.s5 : largest;
  largest = (maxValue.s6 > largest) ? maxValue.s6 : largest;
  largest = (maxValue.s7 > largest) ? maxValue.s7 : largest;

  float8 largest8 = (float8)largest;
  float8 sum8 = (float8)0;
  float sum = 0;

  for (i = 0; i < 10; i++) {
    localInput[hook(7, i)] = exp(localInput[hook(7, i)] - largest8);
    sum8 += localInput[hook(7, i)];
  }

  sum = sum8.s0 + sum8.s1 + sum8.s2 + sum8.s3 + sum8.s4 + sum8.s5 + sum8.s6 + sum8.s7;

  for (i = 0; i < 10; i++) {
    localInput[hook(7, i)] /= sum;
    vstore8(localInput[hook(7, i)], 0, &x[hook(8, i * 8)]);
    tempValue = vload_half8(0, &x[hook(8, i * 8)]);

    vstore8(tempValue, 0, &xOut[hook(9, i * 8)]);
  }
}

kernel void softmax(int n, int offset, int batch, global float* input, float temp, global float* output, int base) {
  int stepSize = get_local_size(0);
  int idx = get_global_id(0) * stepSize;
  int count = 0, i = 0;
  int baseIdxOffset = 0;

  for (; count < 2; count++) {
    baseIdxOffset = base + idx * offset;
    softmax_device_optimized(input + baseIdxOffset, output + baseIdxOffset);
    idx = idx + 1;
  }
}