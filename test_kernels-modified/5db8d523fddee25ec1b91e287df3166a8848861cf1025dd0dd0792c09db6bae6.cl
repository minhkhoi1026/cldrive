//{"in":0,"inBuf":7,"inLocal":4,"offset":3,"offsetLocal":6,"out":1,"weight":2,"weightBuf":8,"weightLocal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}
__attribute__((reqd_work_group_size(12, 1, 1))) kernel void full6(global float* in, global float* out, constant float* weight, constant float* offset) {
  int o = get_global_id(0);
  int oLocal = get_local_id(0);

  local float inLocal[120];
  local float weightLocal[12 * 120];
  local float offsetLocal[12];

  if (oLocal == 0) {
    for (int i = 0; i < 120; ++i) {
      inLocal[hook(4, i)] = in[hook(0, i)];
    }

    for (int i = 0; i < 12 * 120; ++i) {
      weightLocal[hook(5, i)] = weight[hook(2, o * 120 + i)];
    }

    for (int i = 0; i < 12; ++i) {
      offsetLocal[hook(6, i)] = offset[hook(3, o + i)];
    }
  }

  barrier(0x01);

  if (o < 84) {
    float sum = 0;

    float inBuf[10];
    float weightBuf[10];
    for (int i = 0; i < 120; i += 10) {
      for (int j = 0; j < 10; ++j) {
        inBuf[hook(7, j)] = inLocal[hook(4, i + j)];
        weightBuf[hook(8, j)] = weightLocal[hook(5, oLocal * 120 + i + j)];
      }

      for (int j = 0; j < 10; ++j) {
        sum += weightBuf[hook(8, j)] * inBuf[hook(7, j)];
      }
    }
    sum += offsetLocal[hook(6, oLocal)];
    out[hook(1, o)] = sigmod(sum);
  }
}