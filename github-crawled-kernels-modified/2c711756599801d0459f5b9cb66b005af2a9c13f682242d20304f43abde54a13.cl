//{"<recovery-expr>()":4,"inBuf":6,"inLocal":3,"offset":2,"out":0,"weight":1,"weightBuf":7,"weightLocal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}
global float buf1[4704];
global float buf2[1176];
global float buf3[1600];
global float buf4[400];
global float buf5[120];
global float buf6[84];
__attribute__((reqd_work_group_size(7, 7, 2))) __attribute__((reqd_work_group_size(14, 14, 2))) __attribute__((reqd_work_group_size(2, 2, 4))) __attribute__((reqd_work_group_size(16, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 10))) __attribute__((reqd_work_group_size(12, 1, 1))) __attribute__((reqd_work_group_size(10, 1, 1))) kernel void rbf7(global float* out, global float* weight, global float* offset) {
  int o = get_global_id(0);
  int oLocal = get_local_id(0);

  local float inLocal[84];
  local float weightLocal[84 * 10];

  if (oLocal == 0) {
    for (int i = 0; i < 84; ++i) {
      inLocal[hook(3, i)] = buf6[hook(4, i)];
    }
    for (int i = 0; i < 84 * 10; ++i) {
      weightLocal[hook(5, i)] = weight[hook(1, o * 84 + i)];
    }
  }

  barrier(0x01);

  if (o < 10) {
    float sum = 0.0f;

    float inBuf[14];
    float weightBuf[14];

    for (int i = 0; i < 84; i += 14) {
      for (int j = 0; j < 14; ++j) {
        inBuf[hook(6, j)] = inLocal[hook(3, i + j)];
        weightBuf[hook(7, j)] = weightLocal[hook(5, oLocal * 84 + i + j)];
      }

      for (int j = 0; j < 14; ++j) {
        float diff = weightBuf[hook(7, j)] - inBuf[hook(6, j)];
        sum += diff * diff;
      }
    }
    out[hook(0, o)] = sum;
  }
}