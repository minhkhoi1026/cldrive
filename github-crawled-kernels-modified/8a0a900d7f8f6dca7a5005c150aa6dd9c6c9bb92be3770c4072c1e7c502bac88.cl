//{"in_c":3,"in_h":1,"in_w":2,"input":7,"localInput":9,"n":0,"output":8,"pad":6,"size":5,"stride":4,"x":10,"xOut":11}
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
  localInput[hook(9, 0)] = vload8(0, &x[hook(10, 0)]);
  localInput[hook(9, 1)] = vload8(0, &x[hook(10, 8)]);
  localInput[hook(9, 2)] = vload8(0, &x[hook(10, 16)]);
  localInput[hook(9, 3)] = vload8(0, &x[hook(10, 24)]);
  localInput[hook(9, 4)] = vload8(0, &x[hook(10, 32)]);
  localInput[hook(9, 5)] = vload8(0, &x[hook(10, 40)]);
  localInput[hook(9, 6)] = vload8(0, &x[hook(10, 48)]);
  localInput[hook(9, 7)] = vload8(0, &x[hook(10, 56)]);
  localInput[hook(9, 8)] = vload8(0, &x[hook(10, 64)]);
  localInput[hook(9, 9)] = vload8(0, &x[hook(10, 72)]);

  float8 maxValue;
  float largest = 0;

  maxValue = max(localInput[hook(9, 0)], localInput[hook(9, 1)]);
  maxValue = max(maxValue, localInput[hook(9, 2)]);
  maxValue = max(maxValue, localInput[hook(9, 3)]);
  maxValue = max(maxValue, localInput[hook(9, 4)]);
  maxValue = max(maxValue, localInput[hook(9, 5)]);
  maxValue = max(maxValue, localInput[hook(9, 6)]);
  maxValue = max(maxValue, localInput[hook(9, 7)]);
  maxValue = max(maxValue, localInput[hook(9, 8)]);
  maxValue = max(maxValue, localInput[hook(9, 9)]);
  maxValue = max(maxValue, localInput[hook(9, 10)]);

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
    localInput[hook(9, i)] = exp(localInput[hook(9, i)] - largest8);
    sum8 += localInput[hook(9, i)];
  }

  sum = sum8.s0 + sum8.s1 + sum8.s2 + sum8.s3 + sum8.s4 + sum8.s5 + sum8.s6 + sum8.s7;

  for (i = 0; i < 10; i++) {
    localInput[hook(9, i)] /= sum;
    vstore8(localInput[hook(9, i)], 0, &x[hook(10, i * 8)]);
    tempValue = vload_half8(0, &x[hook(10, i * 8)]);

    vstore8(tempValue, 0, &xOut[hook(11, i * 8)]);
  }
}

kernel void maxpool(int n, int in_h, int in_w, int in_c, int stride, int size, int pad, global float* input, global float* output) {
  int h = (in_h + 2 * pad) / stride;
  int w = (in_w + 2 * pad) / stride;
  int c = in_c;

  int stepSize = get_local_size(0);
  int idx = get_global_id(0) * stepSize;

  int count = 0, id = 0;
  int j, i, k, w_offset, h_offset, out_index, l, m, cur_h, cur_w, index, valid;
  float maxVal, val;

  for (; count < 8; count++) {
    id = idx;
    j = id % w;
    id /= w;
    i = id % h;
    id /= h;
    k = id % c;
    id /= c;

    w_offset = -pad;
    h_offset = -pad;

    out_index = j + w * (i + h * k);
    maxVal = -(__builtin_inff());

    for (l = 0; l < 2; ++l) {
      for (m = 0; m < 2; ++m) {
        cur_h = h_offset + i * stride + l;
        cur_w = w_offset + j * stride + m;
        index = cur_w + in_w * (cur_h + in_h * k);
        valid = (cur_h >= 0 && cur_h < in_h && cur_w >= 0 && cur_w < in_w);
        val = (valid != 0) ? input[hook(7, index)] : -(__builtin_inff());
        maxVal = (val > maxVal) ? val : maxVal;
      }
    }
    output[hook(8, out_index)] = maxVal;
    idx = idx + 1;
  }
}