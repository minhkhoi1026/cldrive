//{"<recovery-expr>(buf1)":7,"in":0,"inLocal":3,"offset":2,"offsetLocal":5,"outPrivate":6,"weight":1,"weightLocal":4}
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
__attribute__((reqd_work_group_size(7, 7, 2))) kernel void conv1(global float* in, constant float* weight, constant float* offset) {
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
      inLocal[hook(3, i)] = in[hook(0, i)];
    }

    for (int i = 0; i < 1 * 6 * 25; ++i) {
      weightLocal[hook(4, i)] = weight[hook(1, i)];
    }

    for (int i = 0; i < 6; ++i) {
      offsetLocal[hook(5, i)] = offset[hook(2, i)];
    }
  }

  barrier(0x01);

  float outPrivate[4 * 4 * 3];

  for (int i = 0; i < 4 * 4 * 3; ++i) {
    outPrivate[hook(6, i)] = 0.0f;
  }

  for (int iTile = 0; iTile < 1; iTile += 1) {
    int oPrivateIdx = 0;

    for (int r = rTile; r < rTile + 4; ++r) {
      for (int c = cTile; c < cTile + 4; ++c) {
        for (int o = oTile; o < oTile + 3; ++o, ++oPrivateIdx) {
          for (int i = iTile; i < iTile + 1; ++i) {
            int weightIdx = 0;
            for (int x = 0; x < 5; ++x) {
              for (int y = 0; y < 5; ++y, ++weightIdx) {
                outPrivate[hook(6, oPrivateIdx)] += inLocal[hook(3, (i * 32 + r + x) * 32 + c + y)] * weightLocal[hook(4, (o * 1 + i) * 25 + weightIdx)];
              }
            }
          }
        }
      }
    }
  }

  int oPrivateIdx = 0;
  for (int r = rTile; r < rTile + 4; ++r) {
    for (int c = cTile; c < cTile + 4; ++c) {
      for (int o = oTile; o < oTile + 3; ++o, ++oPrivateIdx) {
        buf1[hook(7, (o * 28 + r) * 28 + c)] = sigmod(outPrivate[hook(6, oPrivateIdx)] + offsetLocal[hook(5, o)]);
      }
    }
  }
}