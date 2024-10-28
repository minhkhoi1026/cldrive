//{"Certainty":2,"DATA_D":7,"DATA_H":6,"DATA_T":8,"DATA_W":5,"Filter_Response":0,"Volume":1,"c_Smoothing_Filter_Y":3,"l_Volume":11,"l_Volume[tIdx.z + 2]":13,"l_Volume[tIdx.z + 2][tIdx.y + 0]":30,"l_Volume[tIdx.z + 2][tIdx.y + 1]":31,"l_Volume[tIdx.z + 2][tIdx.y + 2]":32,"l_Volume[tIdx.z + 2][tIdx.y + 3]":33,"l_Volume[tIdx.z + 2][tIdx.y + 4]":34,"l_Volume[tIdx.z + 2][tIdx.y + 5]":35,"l_Volume[tIdx.z + 2][tIdx.y + 6]":36,"l_Volume[tIdx.z + 2][tIdx.y + 7]":37,"l_Volume[tIdx.z + 2][tIdx.y + 8]":19,"l_Volume[tIdx.z + 2][tIdx.y]":12,"l_Volume[tIdx.z + 4]":15,"l_Volume[tIdx.z + 4][tIdx.y + 0]":38,"l_Volume[tIdx.z + 4][tIdx.y + 1]":39,"l_Volume[tIdx.z + 4][tIdx.y + 2]":40,"l_Volume[tIdx.z + 4][tIdx.y + 3]":41,"l_Volume[tIdx.z + 4][tIdx.y + 4]":42,"l_Volume[tIdx.z + 4][tIdx.y + 5]":43,"l_Volume[tIdx.z + 4][tIdx.y + 6]":44,"l_Volume[tIdx.z + 4][tIdx.y + 7]":45,"l_Volume[tIdx.z + 4][tIdx.y + 8]":20,"l_Volume[tIdx.z + 4][tIdx.y]":14,"l_Volume[tIdx.z + 6]":17,"l_Volume[tIdx.z + 6][tIdx.y + 0]":46,"l_Volume[tIdx.z + 6][tIdx.y + 1]":47,"l_Volume[tIdx.z + 6][tIdx.y + 2]":48,"l_Volume[tIdx.z + 6][tIdx.y + 3]":49,"l_Volume[tIdx.z + 6][tIdx.y + 4]":50,"l_Volume[tIdx.z + 6][tIdx.y + 5]":51,"l_Volume[tIdx.z + 6][tIdx.y + 6]":52,"l_Volume[tIdx.z + 6][tIdx.y + 7]":53,"l_Volume[tIdx.z + 6][tIdx.y + 8]":21,"l_Volume[tIdx.z + 6][tIdx.y]":16,"l_Volume[tIdx.z]":10,"l_Volume[tIdx.z][tIdx.y + 0]":22,"l_Volume[tIdx.z][tIdx.y + 1]":23,"l_Volume[tIdx.z][tIdx.y + 2]":24,"l_Volume[tIdx.z][tIdx.y + 3]":25,"l_Volume[tIdx.z][tIdx.y + 4]":26,"l_Volume[tIdx.z][tIdx.y + 5]":27,"l_Volume[tIdx.z][tIdx.y + 6]":28,"l_Volume[tIdx.z][tIdx.y + 7]":29,"l_Volume[tIdx.z][tIdx.y + 8]":18,"l_Volume[tIdx.z][tIdx.y]":9,"t":4}
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
kernel void SeparableConvolutionRows_16KB_512threads(global float* Filter_Response, global const float* Volume, global const float* Certainty, constant float* c_Smoothing_Filter_Y, private int t, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_group_id(2) * 8 + get_local_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  local float l_Volume[8][16][32];

  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y)][hook(9, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y)][hook(12, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y)][hook(14, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y)][hook(16, tIdx.x)] = 0.0f;

  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 8)][hook(18, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 8)][hook(19, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 8)][hook(20, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 8)][hook(21, tIdx.x)] = 0.0f;

  if ((x < DATA_W) && ((y - 4) >= 0) && ((y - 4) < DATA_H) && (z < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y)][hook(9, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y - 4, z, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y - 4, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y - 4) >= 0) && ((y - 4) < DATA_H) && ((z + 2) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y)][hook(12, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y - 4, z + 2, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y - 4, z + 2, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y - 4) >= 0) && ((y - 4) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y)][hook(14, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y - 4, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y - 4) >= 0) && ((y - 4) < DATA_H) && ((z + 6) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y)][hook(16, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y - 4, z + 6, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y - 4, z + 6, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && (z < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 8)][hook(18, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y + 4, z, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y + 4, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z + 2) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 8)][hook(19, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y + 4, z + 2, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y + 4, z + 2, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 8)][hook(20, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y + 4, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z + 6) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 8)][hook(21, tIdx.x)] = Volume[hook(1, Calculate4DIndex(x, y + 4, z + 6, t, DATA_W, DATA_H, DATA_D))] * Certainty[hook(2, Calculate3DIndex(x, y + 4, z + 6, DATA_W, DATA_H))];
  }

  barrier(0x01);

  if ((x < DATA_W) && (y < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 0)][hook(22, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 1)][hook(23, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 2)][hook(24, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 3)][hook(25, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 4)][hook(26, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 5)][hook(27, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 6)][hook(28, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 7)][hook(29, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 8)][hook(18, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 0)];

    Filter_Response[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = sum;
  }

  if ((x < DATA_W) && (y < DATA_H) && ((z + 2) < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 0)][hook(30, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 1)][hook(31, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 2)][hook(32, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 3)][hook(33, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 4)][hook(34, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 5)][hook(35, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 6)][hook(36, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 7)][hook(37, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(13, tIdx.y + 8)][hook(19, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 0)];

    Filter_Response[hook(0, Calculate3DIndex(x, y, z + 2, DATA_W, DATA_H))] = sum;
  }

  if ((x < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 0)][hook(38, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 1)][hook(39, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 2)][hook(40, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 3)][hook(41, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 4)][hook(42, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 5)][hook(43, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 6)][hook(44, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 7)][hook(45, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(15, tIdx.y + 8)][hook(20, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 0)];

    Filter_Response[hook(0, Calculate3DIndex(x, y, z + 4, DATA_W, DATA_H))] = sum;
  }

  if ((x < DATA_W) && (y < DATA_H) && ((z + 6) < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 0)][hook(46, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 1)][hook(47, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 2)][hook(48, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 3)][hook(49, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 4)][hook(50, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 5)][hook(51, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 6)][hook(52, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 7)][hook(53, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(17, tIdx.y + 8)][hook(21, tIdx.x)] * c_Smoothing_Filter_Y[hook(3, 0)];

    Filter_Response[hook(0, Calculate3DIndex(x, y, z + 6, DATA_W, DATA_H))] = sum;
  }
}