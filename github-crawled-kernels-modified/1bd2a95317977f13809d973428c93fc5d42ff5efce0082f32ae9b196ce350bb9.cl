//{"<recovery-expr>()":3,"<recovery-expr>(buf6)":8,"inBuf":6,"inLocal":2,"offset":1,"offsetLocal":5,"weight":0,"weightBuf":7,"weightLocal":4}
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
__attribute__((reqd_work_group_size(7, 7, 2))) __attribute__((reqd_work_group_size(14, 14, 2))) __attribute__((reqd_work_group_size(2, 2, 4))) __attribute__((reqd_work_group_size(16, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 10))) __attribute__((reqd_work_group_size(12, 1, 1))) kernel void full6(

    constant float* weight, constant float* offset) {
  int o = get_global_id(0);
  int oLocal = get_local_id(0);

  local float inLocal[120];
  local float weightLocal[12 * 120];
  local float offsetLocal[12];

  if (oLocal == 0) {
    for (int i = 0; i < 120; ++i) {
      inLocal[hook(2, i)] = buf5[hook(3, i)];
    }

    for (int i = 0; i < 12 * 120; ++i) {
      weightLocal[hook(4, i)] = weight[hook(0, o * 120 + i)];
    }

    for (int i = 0; i < 12; ++i) {
      offsetLocal[hook(5, i)] = offset[hook(1, o + i)];
    }
  }

  barrier(0x01);

  if (o < 84) {
    float sum = 0;

    float inBuf[10];
    float weightBuf[10];
    for (int i = 0; i < 120; i += 10) {
      for (int j = 0; j < 10; ++j) {
        inBuf[hook(6, j)] = inLocal[hook(2, i + j)];
        weightBuf[hook(7, j)] = weightLocal[hook(4, oLocal * 120 + i + j)];
      }

      for (int j = 0; j < 10; ++j) {
        sum += weightBuf[hook(7, j)] * inBuf[hook(6, j)];
      }
    }
    sum += offsetLocal[hook(5, oLocal)];
    buf6[hook(8, o)] = sigmod(sum);
  }
}