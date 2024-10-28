//{"DATA_D":6,"DATA_H":5,"DATA_T":7,"DATA_W":4,"Filter_Response":0,"Volume":1,"c_Smoothing_Filter_X":2,"l_Volume":10,"l_Volume[tIdx.z + 2]":12,"l_Volume[tIdx.z + 2][tIdx.y + 8]":18,"l_Volume[tIdx.z + 2][tIdx.y]":11,"l_Volume[tIdx.z + 4]":14,"l_Volume[tIdx.z + 4][tIdx.y + 8]":19,"l_Volume[tIdx.z + 4][tIdx.y]":13,"l_Volume[tIdx.z + 6]":16,"l_Volume[tIdx.z + 6][tIdx.y + 8]":20,"l_Volume[tIdx.z + 6][tIdx.y]":15,"l_Volume[tIdx.z]":9,"l_Volume[tIdx.z][tIdx.y + 8]":17,"l_Volume[tIdx.z][tIdx.y]":8,"t":3}
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

int Calculate5DIndex(int x, int y, int z, int t, int v, int DATA_W, int DATA_H, int DATA_D, int VALUES) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D + v * DATA_W * DATA_H * DATA_D * VALUES;
}

void GetParameterIndices(int* i, int* j, int parameter) {
  switch (parameter) {
    case 0:
      *i = 0;
      *j = 0;
      break;

    case 1:
      *i = 3;
      *j = 0;
      break;

    case 2:
      *i = 4;
      *j = 0;
      break;

    case 3:
      *i = 5;
      *j = 0;
      break;

    case 4:
      *i = 3;
      *j = 3;
      break;

    case 5:
      *i = 4;
      *j = 3;
      break;

    case 6:
      *i = 5;
      *j = 3;
      break;

    case 7:
      *i = 4;
      *j = 4;
      break;

    case 8:
      *i = 5;
      *j = 4;
      break;

    case 9:
      *i = 5;
      *j = 5;
      break;

    case 10:
      *i = 1;
      *j = 1;
      break;

    case 11:
      *i = 6;
      *j = 1;
      break;

    case 12:
      *i = 7;
      *j = 1;
      break;

    case 13:
      *i = 8;
      *j = 1;
      break;

    case 14:
      *i = 6;
      *j = 6;
      break;

    case 15:
      *i = 7;
      *j = 6;
      break;

    case 16:
      *i = 8;
      *j = 6;
      break;

    case 17:
      *i = 7;
      *j = 7;
      break;

    case 18:
      *i = 8;
      *j = 7;
      break;

    case 19:
      *i = 8;
      *j = 8;
      break;

    case 20:
      *i = 2;
      *j = 2;
      break;

    case 21:
      *i = 9;
      *j = 2;
      break;

    case 22:
      *i = 10;
      *j = 2;
      break;

    case 23:
      *i = 11;
      *j = 2;
      break;

    case 24:
      *i = 9;
      *j = 9;
      break;

    case 25:
      *i = 10;
      *j = 9;
      break;

    case 26:
      *i = 11;
      *j = 9;
      break;

    case 27:
      *i = 10;
      *j = 10;
      break;

    case 28:
      *i = 11;
      *j = 10;
      break;

    case 29:
      *i = 11;
      *j = 11;
      break;

    default:
      *i = 0;
      *j = 0;
      break;
  }
}
kernel void SeparableConvolutionColumns_16KB_512threads(global float* Filter_Response, global float* Volume, constant float* c_Smoothing_Filter_X, private int t, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_group_id(0) * 24 + get_local_id(0);
  int y = get_group_id(1) * 16 + get_local_id(1);
  int z = get_group_id(2) * 8 + get_local_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  local float l_Volume[8][16][32];

  l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x)] = 0.0f;

  l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x)] = 0.0f;
  l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x)] = 0.0f;

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && (z < DATA_D)) {
    l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y)][hook(8, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 2) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 2, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 4, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && (y < DATA_H) && ((z + 6) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y, z + 6, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && (z < DATA_D)) {
    l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 2) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 2, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 4, DATA_W, DATA_H))];
  }

  if (((x - 4) >= 0) && ((x - 4) < DATA_W) && ((y + 8) < DATA_H) && ((z + 6) < DATA_D)) {
    l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x - 4, y + 8, z + 6, DATA_W, DATA_H))];
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

    if ((x < DATA_W) && (y < DATA_H) && ((z + 2) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y)][hook(11, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 2, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y)][hook(13, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 4, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && (y < DATA_H) && ((z + 6) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y)][hook(15, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y, z + 6, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && (z < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z)][hook(9, tIdx.y + 8)][hook(17, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 2) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 2)][hook(12, tIdx.y + 8)][hook(18, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 2, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 4) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 4)][hook(14, tIdx.y + 8)][hook(19, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 4, DATA_W, DATA_H))] = sum;
    }

    if ((x < DATA_W) && ((y + 8) < DATA_H) && ((z + 6) < DATA_D)) {
      float sum = 0.0f;

      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 0)] * c_Smoothing_Filter_X[hook(2, 8)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 1)] * c_Smoothing_Filter_X[hook(2, 7)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 2)] * c_Smoothing_Filter_X[hook(2, 6)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 3)] * c_Smoothing_Filter_X[hook(2, 5)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 4)] * c_Smoothing_Filter_X[hook(2, 4)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 5)] * c_Smoothing_Filter_X[hook(2, 3)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 6)] * c_Smoothing_Filter_X[hook(2, 2)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 7)] * c_Smoothing_Filter_X[hook(2, 1)];
      sum += l_Volume[hook(10, tIdx.z + 6)][hook(16, tIdx.y + 8)][hook(20, tIdx.x + 8)] * c_Smoothing_Filter_X[hook(2, 0)];

      Filter_Response[hook(0, Calculate3DIndex(x, y + 8, z + 6, DATA_W, DATA_H))] = sum;
    }
  }
}