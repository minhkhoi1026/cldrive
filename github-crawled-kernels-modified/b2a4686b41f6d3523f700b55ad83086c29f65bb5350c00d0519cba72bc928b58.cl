//{"DATA_D":6,"DATA_H":5,"DATA_T":7,"DATA_W":4,"Filter_Response":0,"Volume":1,"c_Smoothing_Filter_X":2,"l_Volume":10,"l_Volume[tIdx.z + 1]":12,"l_Volume[tIdx.z + 1][tIdx.y + 8]":26,"l_Volume[tIdx.z + 1][tIdx.y]":11,"l_Volume[tIdx.z + 2]":14,"l_Volume[tIdx.z + 2][tIdx.y + 8]":27,"l_Volume[tIdx.z + 2][tIdx.y]":13,"l_Volume[tIdx.z + 3]":16,"l_Volume[tIdx.z + 3][tIdx.y + 8]":28,"l_Volume[tIdx.z + 3][tIdx.y]":15,"l_Volume[tIdx.z + 4]":18,"l_Volume[tIdx.z + 4][tIdx.y + 8]":29,"l_Volume[tIdx.z + 4][tIdx.y]":17,"l_Volume[tIdx.z + 5]":20,"l_Volume[tIdx.z + 5][tIdx.y + 8]":30,"l_Volume[tIdx.z + 5][tIdx.y]":19,"l_Volume[tIdx.z + 6]":22,"l_Volume[tIdx.z + 6][tIdx.y + 8]":31,"l_Volume[tIdx.z + 6][tIdx.y]":21,"l_Volume[tIdx.z + 7]":24,"l_Volume[tIdx.z + 7][tIdx.y + 8]":32,"l_Volume[tIdx.z + 7][tIdx.y]":23,"l_Volume[tIdx.z]":9,"l_Volume[tIdx.z][tIdx.y + 8]":25,"l_Volume[tIdx.z][tIdx.y]":8,"t":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}
kernel void SeparableConvolutionColumns_16KB_256threads(global float* Filter_Response, global float* Volume, constant float* c_Smoothing_Filter_X, private int t, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_group_id(0) * 24 + get_local_id(0);
  int y = get_group_id(1) * 16 + get_local_id(1);
  int z = get_group_id(2) * 8 + get_local_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  local float l_Volume[8][16][32];

  l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x)] = 0.0f;

  l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x)] = 0.0f;

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && (z < DATA_D)) {
    l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 1) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 1, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 2) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 2, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 3) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 3, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 4, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 5) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 5, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 6) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 6, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 7) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 7, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && (z < DATA_D)) {
    l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 1) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 1, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 2) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 2, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 3) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 3, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 4, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 5) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 5, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 6) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 6, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 7) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 7, DATA_W, DATA_H))];
  }

  barrier(0x01);

  if (tIdx.x < 24) {
    if ((x < DATA_W) && (y < DATA_H) && (z < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 1) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y)][hook(11, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 1, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 2) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y)][hook(13, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 2, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 3) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y)][hook(15, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 3, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y)][hook(17, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 4, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 5) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y)][hook(19, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 5, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 6) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y)][hook(21, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 6, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 7) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y)][hook(23, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 7, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && (z < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(25, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 1) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 1)][hook(12, tIdx.y + 8)][hook(26, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 1, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 2) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(14, tIdx.y + 8)][hook(27, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 2, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 3) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 3)][hook(16, tIdx.y + 8)][hook(28, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 3, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 4) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(18, tIdx.y + 8)][hook(29, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 4, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 5) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 5)][hook(20, tIdx.y + 8)][hook(30, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 5, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 6) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(22, tIdx.y + 8)][hook(31, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 6, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 7) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 7)][hook(24, tIdx.y + 8)][hook(32, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 7, DATA_W, DATA_H))] = sum;
    }
  }
}