//{"in":0,"inLocal":4,"offset":3,"offsetLocal":6,"out":1,"outPrivate":7,"weight":2,"weightLocal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}
__attribute__((reqd_work_group_size(7, 7, 2))) kernel void conv1(global float* in, global float* out, constant float* weight, constant float* offset) {
  int cTile = get_global_id(0) * 4;
  int rTile = get_global_id(1) * 4;
  int oTile = get_global_id(2) * 3;

  int cLocal = get_local_id(0);
  int rLocal = get_local_id(1);
  int oLocal = get_local_id(2);

  local float inLocal[1024];
  local float weightLocal[1 * 6 * 25];
  local float offsetLocal[6];

  if (cLocal == 0 && rLocal == 0 && oLocal == 0) {
    for (int i = 0; i < 1024; ++i) {
      inLocal[hook(4, i)] = in[hook(0, i)];
    }

    for (int i = 0; i < 1 * 6 * 25; ++i) {
      weightLocal[hook(5, i)] = weight[hook(2, i)];
    }

    for (int i = 0; i < 6; ++i) {
      offsetLocal[hook(6, i)] = offset[hook(3, i)];
    }
  }

  barrier(0x01);

  float outPrivate[4 * 4 * 3];

  for (int i = 0; i < 4 * 4 * 3; ++i) {
    outPrivate[hook(7, i)] = 0.0f;
  }

  for (int iTile = 0; iTile < 1; iTile += 1) {
    int oPrivateIdx = 0;
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        for (int o = 0; o < 3; ++o, ++oPrivateIdx) {
          for (int i = 0; i < 1; ++i) {
            int weightIdx = 0;
            for (int x = 0; x < 5; ++x) {
              for (int y = 0; y < 5; ++y, ++weightIdx) {
                outPrivate[hook(7, oPrivateIdx)] += inLocal[hook(4, ((i + iTile) * 32 + r + rTile + x) * 32 + c + cTile + y)] * weightLocal[hook(5, ((o + oTile) * 1 + i + iTile) * 25 + weightIdx)];
              }
            }
          }
        }
      }
    }
  }

  int oPrivateIdx = 0;
  for (int r = 0; r < 4; ++r) {
    for (int c = 0; c < 4; ++c) {
      for (int o = 0; o < 3; ++o, ++oPrivateIdx) {
        out[hook(1, ((o + oTile) * 28 + r + rTile) * 28 + c + cTile)] = sigmod(outPrivate[hook(7, oPrivateIdx)] + offsetLocal[hook(6, o + oTile)]);
      }
    }
  }
}