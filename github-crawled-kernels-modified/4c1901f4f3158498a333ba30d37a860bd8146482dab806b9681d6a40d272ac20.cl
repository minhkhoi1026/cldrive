//{"in":0,"inLocal":4,"offset":3,"offsetLocal":6,"out":1,"weight":2,"weightLocal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}
__attribute__((reqd_work_group_size(14, 14, 2))) kernel void pool2(global float* in, global float* out, global float* weight, global float* offset) {
  int c = get_global_id(0);
  int r = get_global_id(1);
  int o = get_global_id(2);

  int cLocal = get_local_id(0);
  int rLocal = get_local_id(1);
  int oLocal = get_local_id(2);

  local float inLocal[28 * 28 * 6];
  local float weightLocal[2];
  local float offsetLocal[2];

  if (cLocal == 0 && rLocal == 0 && oLocal == 0) {
    for (int i = 0; i < 28 * 28 * 6; ++i) {
      inLocal[hook(4, i)] = in[hook(0, i)];
    }

    for (int i = 0; i < 2; ++i) {
      weightLocal[hook(5, i)] = weight[hook(2, o + i)];
      offsetLocal[hook(6, i)] = offset[hook(3, o + i)];
    }
  }

  barrier(0x01);

  if (c < 14 && r < 14 && o < 6) {
    float sum = 0.0f;

    for (int x = 0; x < 2; ++x) {
      for (int y = 0; y < 2; ++y) {
        sum += inLocal[hook(4, (o * 28 + r * 2 + x) * 28 + c * 2 + y)];
      }
    }

    sum = sum * weightLocal[hook(5, oLocal)] + offsetLocal[hook(6, oLocal)];

    int outIdx = (o * 14 + r) * 14 + c;
    out[hook(1, outIdx)] = sigmod(sum);
  }
}