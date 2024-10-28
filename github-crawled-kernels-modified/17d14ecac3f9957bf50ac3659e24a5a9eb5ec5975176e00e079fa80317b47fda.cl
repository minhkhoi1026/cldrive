//{"DATA_D":7,"DATA_H":6,"DATA_T":8,"DATA_W":5,"Filter_Response":0,"Smoothed_Certainty":2,"Volume":1,"c_Smoothing_Filter_Z":3,"l_Volume":11,"l_Volume[tIdx.z + 0]":29,"l_Volume[tIdx.z + 0][tIdx.y + 1]":44,"l_Volume[tIdx.z + 0][tIdx.y + 2]":52,"l_Volume[tIdx.z + 0][tIdx.y + 3]":60,"l_Volume[tIdx.z + 0][tIdx.y + 4]":68,"l_Volume[tIdx.z + 0][tIdx.y + 5]":76,"l_Volume[tIdx.z + 0][tIdx.y + 6]":84,"l_Volume[tIdx.z + 0][tIdx.y + 7]":92,"l_Volume[tIdx.z + 0][tIdx.y]":28,"l_Volume[tIdx.z + 1]":31,"l_Volume[tIdx.z + 1][tIdx.y + 1]":45,"l_Volume[tIdx.z + 1][tIdx.y + 2]":53,"l_Volume[tIdx.z + 1][tIdx.y + 3]":61,"l_Volume[tIdx.z + 1][tIdx.y + 4]":69,"l_Volume[tIdx.z + 1][tIdx.y + 5]":77,"l_Volume[tIdx.z + 1][tIdx.y + 6]":85,"l_Volume[tIdx.z + 1][tIdx.y + 7]":93,"l_Volume[tIdx.z + 1][tIdx.y]":30,"l_Volume[tIdx.z + 2]":33,"l_Volume[tIdx.z + 2][tIdx.y + 1]":46,"l_Volume[tIdx.z + 2][tIdx.y + 2]":54,"l_Volume[tIdx.z + 2][tIdx.y + 3]":62,"l_Volume[tIdx.z + 2][tIdx.y + 4]":70,"l_Volume[tIdx.z + 2][tIdx.y + 5]":78,"l_Volume[tIdx.z + 2][tIdx.y + 6]":86,"l_Volume[tIdx.z + 2][tIdx.y + 7]":94,"l_Volume[tIdx.z + 2][tIdx.y]":32,"l_Volume[tIdx.z + 3]":35,"l_Volume[tIdx.z + 3][tIdx.y + 1]":47,"l_Volume[tIdx.z + 3][tIdx.y + 2]":55,"l_Volume[tIdx.z + 3][tIdx.y + 3]":63,"l_Volume[tIdx.z + 3][tIdx.y + 4]":71,"l_Volume[tIdx.z + 3][tIdx.y + 5]":79,"l_Volume[tIdx.z + 3][tIdx.y + 6]":87,"l_Volume[tIdx.z + 3][tIdx.y + 7]":95,"l_Volume[tIdx.z + 3][tIdx.y]":34,"l_Volume[tIdx.z + 4]":37,"l_Volume[tIdx.z + 4][tIdx.y + 1]":48,"l_Volume[tIdx.z + 4][tIdx.y + 2]":56,"l_Volume[tIdx.z + 4][tIdx.y + 3]":64,"l_Volume[tIdx.z + 4][tIdx.y + 4]":72,"l_Volume[tIdx.z + 4][tIdx.y + 5]":80,"l_Volume[tIdx.z + 4][tIdx.y + 6]":88,"l_Volume[tIdx.z + 4][tIdx.y + 7]":96,"l_Volume[tIdx.z + 4][tIdx.y]":36,"l_Volume[tIdx.z + 5]":39,"l_Volume[tIdx.z + 5][tIdx.y + 1]":49,"l_Volume[tIdx.z + 5][tIdx.y + 2]":57,"l_Volume[tIdx.z + 5][tIdx.y + 3]":65,"l_Volume[tIdx.z + 5][tIdx.y + 4]":73,"l_Volume[tIdx.z + 5][tIdx.y + 5]":81,"l_Volume[tIdx.z + 5][tIdx.y + 6]":89,"l_Volume[tIdx.z + 5][tIdx.y + 7]":97,"l_Volume[tIdx.z + 5][tIdx.y]":38,"l_Volume[tIdx.z + 6]":41,"l_Volume[tIdx.z + 6][tIdx.y + 1]":50,"l_Volume[tIdx.z + 6][tIdx.y + 2]":58,"l_Volume[tIdx.z + 6][tIdx.y + 3]":66,"l_Volume[tIdx.z + 6][tIdx.y + 4]":74,"l_Volume[tIdx.z + 6][tIdx.y + 5]":82,"l_Volume[tIdx.z + 6][tIdx.y + 6]":90,"l_Volume[tIdx.z + 6][tIdx.y + 7]":98,"l_Volume[tIdx.z + 6][tIdx.y]":40,"l_Volume[tIdx.z + 7]":43,"l_Volume[tIdx.z + 7][tIdx.y + 1]":51,"l_Volume[tIdx.z + 7][tIdx.y + 2]":59,"l_Volume[tIdx.z + 7][tIdx.y + 3]":67,"l_Volume[tIdx.z + 7][tIdx.y + 4]":75,"l_Volume[tIdx.z + 7][tIdx.y + 5]":83,"l_Volume[tIdx.z + 7][tIdx.y + 6]":91,"l_Volume[tIdx.z + 7][tIdx.y + 7]":99,"l_Volume[tIdx.z + 7][tIdx.y]":42,"l_Volume[tIdx.z + 8]":20,"l_Volume[tIdx.z + 8][tIdx.y + 1]":21,"l_Volume[tIdx.z + 8][tIdx.y + 2]":22,"l_Volume[tIdx.z + 8][tIdx.y + 3]":23,"l_Volume[tIdx.z + 8][tIdx.y + 4]":24,"l_Volume[tIdx.z + 8][tIdx.y + 5]":25,"l_Volume[tIdx.z + 8][tIdx.y + 6]":26,"l_Volume[tIdx.z + 8][tIdx.y + 7]":27,"l_Volume[tIdx.z + 8][tIdx.y]":19,"l_Volume[tIdx.z]":10,"l_Volume[tIdx.z][tIdx.y + 1]":12,"l_Volume[tIdx.z][tIdx.y + 2]":13,"l_Volume[tIdx.z][tIdx.y + 3]":14,"l_Volume[tIdx.z][tIdx.y + 4]":15,"l_Volume[tIdx.z][tIdx.y + 5]":16,"l_Volume[tIdx.z][tIdx.y + 6]":17,"l_Volume[tIdx.z][tIdx.y + 7]":18,"l_Volume[tIdx.z][tIdx.y]":9,"t":4}
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
kernel void SeparableConvolutionRods_16KB_256threads(global float* Filter_Response, global float* Volume, global const float* Smoothed_Certainty, constant float* c_Smoothing_Filter_Z, private int t, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_global_id(0);
  int y = get_group_id(1) * 8 + get_local_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  local float l_Volume[16][8][32];

  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y)][hook(9, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 1)][hook(12, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 2)][hook(13, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 3)][hook(14, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 4)][hook(15, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 5)][hook(16, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 6)][hook(17, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 7)][hook(18, tIdx.x)] = 0.0f;

  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y)][hook(19, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 1)][hook(21, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 2)][hook(22, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 3)][hook(23, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 4)][hook(24, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 5)][hook(25, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 6)][hook(26, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 7)][hook(27, tIdx.x)] = 0.0f;

  if ((x < DATA_W) && (y < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y)][hook(9, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 1) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 1)][hook(12, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 1, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 2) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 2)][hook(13, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 2, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 3) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 3)][hook(14, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 3, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 4)][hook(15, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 4, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 5) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 5)][hook(16, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 5, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 6) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 6)][hook(17, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 6, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 7) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 7)][hook(18, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 7, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y)][hook(19, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 1) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 1)][hook(21, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 1, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 2) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 2)][hook(22, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 2, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 3) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 3)][hook(23, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 3, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 4)][hook(24, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 4, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 5) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 5)][hook(25, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 5, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 6) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 6)][hook(26, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 6, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 7) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 7)][hook(27, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 7, z + 4, DATA_W, DATA_H))];
  }

  barrier(0x01);

  if ((x < DATA_W) && (y < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y)][hook(28, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y)][hook(30, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y)][hook(32, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y)][hook(34, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y)][hook(36, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y)][hook(38, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y)][hook(40, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y)][hook(42, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y)][hook(19, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 1) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 1)][hook(44, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 1)][hook(45, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 1)][hook(46, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 1)][hook(47, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 1)][hook(48, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 1)][hook(49, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 1)][hook(50, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 1)][hook(51, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 1)][hook(21, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 1, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 1, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 2) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 2)][hook(52, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 2)][hook(53, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 2)][hook(54, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 2)][hook(55, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 2)][hook(56, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 2)][hook(57, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 2)][hook(58, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 2)][hook(59, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 2)][hook(22, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 2, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 2, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 3) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 3)][hook(60, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 3)][hook(61, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 3)][hook(62, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 3)][hook(63, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 3)][hook(64, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 3)][hook(65, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 3)][hook(66, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 3)][hook(67, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 3)][hook(23, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 3, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 3, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 4)][hook(68, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 4)][hook(69, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 4)][hook(70, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 4)][hook(71, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 4)][hook(72, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 4)][hook(73, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 4)][hook(74, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 4)][hook(75, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 4)][hook(24, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 4, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 4, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 5) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 5)][hook(76, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 5)][hook(77, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 5)][hook(78, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 5)][hook(79, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 5)][hook(80, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 5)][hook(81, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 5)][hook(82, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 5)][hook(83, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 5)][hook(25, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 5, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 5, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 6) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 6)][hook(84, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 6)][hook(85, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 6)][hook(86, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 6)][hook(87, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 6)][hook(88, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 6)][hook(89, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 6)][hook(90, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 6)][hook(91, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 6)][hook(26, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 6, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 6, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 7) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(29, tIdx.y + 7)][hook(92, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(31, tIdx.y + 7)][hook(93, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(33, tIdx.y + 7)][hook(94, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(35, tIdx.y + 7)][hook(95, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(37, tIdx.y + 7)][hook(96, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(39, tIdx.y + 7)][hook(97, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(41, tIdx.y + 7)][hook(98, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(43, tIdx.y + 7)][hook(99, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(20, tIdx.y + 7)][hook(27, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 7, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 7, z, DATA_W, DATA_H))];
  }
}