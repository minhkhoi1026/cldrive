//{"in":0,"inLocal":4,"inputBuf":6,"offset":3,"out":1,"weight":2,"weightBuf":7,"weightLocal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}
kernel void conv1(global float* in, global float* out, constant float* weight, constant float* offset) {
  int c = get_global_id(0);
  int r = get_global_id(1);
  int o = get_global_id(2);

  int cLocal = get_local_id(0);
  int rLocal = get_local_id(1);
  int oLocal = get_local_id(2);

  local float inLocal[32 * 32 * 1];
  local float weightLocal[1 * 3 * 25];

  if (cLocal == 0 && rLocal == 0 && oLocal == 0) {
    for (int i = 0; i < 32 * 32 * 1; ++i) {
      inLocal[hook(4, i)] = in[hook(0, i)];
    }

    for (int i = 0; i < 1 * 3 * 25; ++i) {
      weightLocal[hook(5, i)] = weight[hook(2, o * 1 * 25 + i)];
    }
  }

  barrier(0x01);

  if (c < 28 && r < 28 && o < 6) {
    float sum = 0.0f;

    for (int i = 0; i < 1; ++i) {
      float inputBuf[25];
      float weightBuf[25];
      int idx = 0;
      int weightBase = (oLocal * 1 + i) * 25;
      for (int x = 0; x < 5; ++x) {
        for (int y = 0; y < 5; ++y) {
          inputBuf[hook(6, idx)] = inLocal[hook(4, (i * 32 + r + x) * 32 + c + y)];
          weightBuf[hook(7, idx)] = weightLocal[hook(5, weightBase + idx)];
          idx++;
        }
      }

      for (int x = 0; x < 25; ++x) {
        sum += inputBuf[hook(6, x)] * weightBuf[hook(7, x)];
      }
    }

    int outIdx = (o * 28 + r) * 28 + c;
    out[hook(1, outIdx)] = sigmod(sum + offset[hook(3, o)]);
  }
}