//{"in":0,"inLocal":4,"offset":3,"offsetLocal":6,"out":1,"outPrivate":7,"weight":2,"weightLocal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}
__attribute__((reqd_work_group_size(2, 2, 4))) kernel void conv3(global float* in, global float* out, constant float* weight, constant float* offset) {
  int cTile = get_global_id(0) * 5;
  int rTile = get_global_id(1) * 5;
  int oTile = get_global_id(2) * 4;

  int cLocal = get_local_id(0);
  int rLocal = get_local_id(1);
  int oLocal = get_local_id(2);

  local float inLocal[1176];
  local float weightLocal[6 * 16 * 25];
  local float offsetLocal[16];

  if (cLocal == 0 && rLocal == 0 && oLocal == 0) {
    for (int i = 0; i < 1176; ++i) {
      inLocal[hook(4, i)] = in[hook(0, i)];
    }

    for (int i = 0; i < 6 * 16 * 25; ++i) {
      weightLocal[hook(5, i)] = weight[hook(2, i)];
    }

    for (int i = 0; i < 16; ++i) {
      offsetLocal[hook(6, i)] = offset[hook(3, i)];
    }
  }

  barrier(0x01);

  float outPrivate[5 * 5 * 4];

  for (int i = 0; i < 5 * 5 * 4; ++i) {
    outPrivate[hook(7, i)] = 0.0f;
  }

  for (int iTile = 0; iTile < 6; iTile += 1) {
    int oPrivateIdx = 0;
    for (int r = 0; r < 5; ++r) {
      for (int c = 0; c < 5; ++c) {
        for (int o = 0; o < 4; ++o, ++oPrivateIdx) {
          for (int i = 0; i < 1; ++i) {
            int weightIdx = 0;
            for (int x = 0; x < 5; ++x) {
              for (int y = 0; y < 5; ++y, ++weightIdx) {
                outPrivate[hook(7, oPrivateIdx)] += inLocal[hook(4, ((i + iTile) * 14 + r + rTile + x) * 14 + c + cTile + y)] * weightLocal[hook(5, ((o + oTile) * 6 + i + iTile) * 25 + weightIdx)];
              }
            }
          }
        }
      }
    }
  }

  int oPrivateIdx = 0;
  for (int r = 0; r < 5; ++r) {
    for (int c = 0; c < 5; ++c) {
      for (int o = 0; o < 4; ++o, ++oPrivateIdx) {
        out[hook(1, ((o + oTile) * 10 + r + rTile) * 10 + c + cTile)] = sigmod(outPrivate[hook(7, oPrivateIdx)] + offsetLocal[hook(6, o + oTile)]);
      }
    }
  }
}