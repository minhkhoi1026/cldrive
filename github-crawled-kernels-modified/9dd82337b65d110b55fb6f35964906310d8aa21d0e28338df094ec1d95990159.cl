//{"<recovery-expr>()":3,"<recovery-expr>(buf3)":7,"inLocal":2,"offset":1,"offsetLocal":5,"outPrivate":6,"weight":0,"weightLocal":4}
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
__attribute__((reqd_work_group_size(7, 7, 2))) __attribute__((reqd_work_group_size(14, 14, 2))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void conv3(

    constant float* weight, constant float* offset) {
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
      inLocal[hook(2, i)] = buf2[hook(3, i)];
    }

    for (int i = 0; i < 6 * 16 * 25; ++i) {
      weightLocal[hook(4, i)] = weight[hook(0, i)];
    }

    for (int i = 0; i < 16; ++i) {
      offsetLocal[hook(5, i)] = offset[hook(1, i)];
    }
  }

  barrier(0x01);

  float outPrivate[5 * 5 * 4];

  for (int i = 0; i < 5 * 5 * 4; ++i) {
    outPrivate[hook(6, i)] = 0.0f;
  }

  for (int iTile = 0; iTile < 6; iTile += 1) {
    int oPrivateIdx = 0;

    for (int r = rTile; r < rTile + 5; ++r) {
      for (int c = cTile; c < cTile + 5; ++c) {
        for (int o = oTile; o < oTile + 4; ++o, ++oPrivateIdx) {
          for (int i = iTile; i < iTile + 1; ++i) {
            int weightIdx = 0;
            for (int x = 0; x < 5; ++x) {
              for (int y = 0; y < 5; ++y, ++weightIdx) {
                outPrivate[hook(6, oPrivateIdx)] += inLocal[hook(2, (i * 14 + r + x) * 14 + c + y)] * weightLocal[hook(4, (o * 6 + i) * 25 + weightIdx)];
              }
            }
          }
        }
      }
    }
  }

  int oPrivateIdx = 0;

  for (int r = rTile; r < rTile + 5; ++r) {
    for (int c = cTile; c < cTile + 5; ++c) {
      for (int o = oTile; o < oTile + 4; ++o, ++oPrivateIdx) {
        buf3[hook(7, (o * 10 + r) * 10 + c)] = sigmod(outPrivate[hook(6, oPrivateIdx)] + offsetLocal[hook(5, o)]);
      }
    }
  }
}