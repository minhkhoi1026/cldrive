//{"<recovery-expr>()":3,"<recovery-expr>(buf4)":6,"inLocal":2,"offset":1,"offsetLocal":5,"weight":0,"weightLocal":4}
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
__attribute__((reqd_work_group_size(7, 7, 2))) __attribute__((reqd_work_group_size(14, 14, 2))) __attribute__((reqd_work_group_size(2, 2, 4))) __attribute__((reqd_work_group_size(16, 1, 1))) kernel void pool4(

    global float* weight, global float* offset) {
  int c = get_global_id(0);
  int r = get_global_id(1);
  int o = get_global_id(2);

  int cLocal = get_local_id(0);
  int rLocal = get_local_id(1);
  int oLocal = get_local_id(2);

  local float inLocal[10 * 10 * 16];
  local float weightLocal[1];
  local float offsetLocal[1];

  if (cLocal == 0 && rLocal == 0 && oLocal == 0) {
    for (int i = 0; i < 10 * 10 * 16; ++i) {
      inLocal[hook(2, i)] = buf3[hook(3, i)];
    }

    for (int i = 0; i < 1; ++i) {
      weightLocal[hook(4, i)] = weight[hook(0, o + i)];
      offsetLocal[hook(5, i)] = offset[hook(1, o + i)];
    }
  }

  barrier(0x01);

  if (c < 5 && r < 5 && o < 16) {
    float sum = 0.0f;

    for (int x = 0; x < 2; ++x) {
      for (int y = 0; y < 2; ++y) {
        sum += inLocal[hook(2, (o * 10 + r * 2 + x) * 10 + c * 2 + y)];
      }
    }

    sum = sum * weightLocal[hook(4, oLocal)] + offsetLocal[hook(5, oLocal)];

    int outIdx = (o * 5 + r) * 5 + c;
    buf4[hook(6, outIdx)] = sigmod(sum);
  }
}