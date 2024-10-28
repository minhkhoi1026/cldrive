//{"DATA_D":7,"DATA_H":6,"DATA_T":8,"DATA_W":5,"Filter_Response":0,"Smoothed_Certainty":2,"Volume":1,"c_Smoothing_Filter_Z":3,"l_Volume":11,"l_Volume[tIdx.z + 0]":21,"l_Volume[tIdx.z + 0][tIdx.y + 2]":36,"l_Volume[tIdx.z + 0][tIdx.y + 4]":44,"l_Volume[tIdx.z + 0][tIdx.y + 6]":52,"l_Volume[tIdx.z + 0][tIdx.y]":20,"l_Volume[tIdx.z + 1]":23,"l_Volume[tIdx.z + 1][tIdx.y + 2]":37,"l_Volume[tIdx.z + 1][tIdx.y + 4]":45,"l_Volume[tIdx.z + 1][tIdx.y + 6]":53,"l_Volume[tIdx.z + 1][tIdx.y]":22,"l_Volume[tIdx.z + 2]":25,"l_Volume[tIdx.z + 2][tIdx.y + 2]":38,"l_Volume[tIdx.z + 2][tIdx.y + 4]":46,"l_Volume[tIdx.z + 2][tIdx.y + 6]":54,"l_Volume[tIdx.z + 2][tIdx.y]":24,"l_Volume[tIdx.z + 3]":27,"l_Volume[tIdx.z + 3][tIdx.y + 2]":39,"l_Volume[tIdx.z + 3][tIdx.y + 4]":47,"l_Volume[tIdx.z + 3][tIdx.y + 6]":55,"l_Volume[tIdx.z + 3][tIdx.y]":26,"l_Volume[tIdx.z + 4]":29,"l_Volume[tIdx.z + 4][tIdx.y + 2]":40,"l_Volume[tIdx.z + 4][tIdx.y + 4]":48,"l_Volume[tIdx.z + 4][tIdx.y + 6]":56,"l_Volume[tIdx.z + 4][tIdx.y]":28,"l_Volume[tIdx.z + 5]":31,"l_Volume[tIdx.z + 5][tIdx.y + 2]":41,"l_Volume[tIdx.z + 5][tIdx.y + 4]":49,"l_Volume[tIdx.z + 5][tIdx.y + 6]":57,"l_Volume[tIdx.z + 5][tIdx.y]":30,"l_Volume[tIdx.z + 6]":33,"l_Volume[tIdx.z + 6][tIdx.y + 2]":42,"l_Volume[tIdx.z + 6][tIdx.y + 4]":50,"l_Volume[tIdx.z + 6][tIdx.y + 6]":58,"l_Volume[tIdx.z + 6][tIdx.y]":32,"l_Volume[tIdx.z + 7]":35,"l_Volume[tIdx.z + 7][tIdx.y + 2]":43,"l_Volume[tIdx.z + 7][tIdx.y + 4]":51,"l_Volume[tIdx.z + 7][tIdx.y + 6]":59,"l_Volume[tIdx.z + 7][tIdx.y]":34,"l_Volume[tIdx.z + 8]":16,"l_Volume[tIdx.z + 8][tIdx.y + 2]":17,"l_Volume[tIdx.z + 8][tIdx.y + 4]":18,"l_Volume[tIdx.z + 8][tIdx.y + 6]":19,"l_Volume[tIdx.z + 8][tIdx.y]":15,"l_Volume[tIdx.z]":10,"l_Volume[tIdx.z][tIdx.y + 2]":12,"l_Volume[tIdx.z][tIdx.y + 4]":13,"l_Volume[tIdx.z][tIdx.y + 6]":14,"l_Volume[tIdx.z][tIdx.y]":9,"t":4}
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
kernel void SeparableConvolutionRods_16KB_512threads(global float* Filter_Response, global float* Volume, global const float* Smoothed_Certainty, constant float* c_Smoothing_Filter_Z, private int t, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_global_id(0);
  int y = get_group_id(1) * 8 + get_local_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  local float l_Volume[16][8][32];

  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y)][hook(9, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 2)][hook(12, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 4)][hook(13, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 6)][hook(14, tIdx.x)] = 0.0f;

  l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y)][hook(15, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 2)][hook(17, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 4)][hook(18, tIdx.x)] = 0.0f;
  l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 6)][hook(19, tIdx.x)] = 0.0f;

  if ((x < DATA_W) && (y < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y)][hook(9, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 2) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 2)][hook(12, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 2, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 4)][hook(13, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 4, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 6) < DATA_H) && ((z - 4) >= 0) && ((z - 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z)][hook(10, tIdx.y + 6)][hook(14, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 6, z - 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && (y < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y)][hook(15, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 2) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 2)][hook(17, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 2, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 4)][hook(18, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 4, z + 4, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 6) < DATA_H) && ((z + 4) < DATA_D)) {
    l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 6)][hook(19, tIdx.x)] = Volume[hook(1, Calculate3DIndex(x, y + 6, z + 4, DATA_W, DATA_H))];
  }

  barrier(0x01);

  if ((x < DATA_W) && (y < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(21, tIdx.y)][hook(20, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(23, tIdx.y)][hook(22, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(25, tIdx.y)][hook(24, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(27, tIdx.y)][hook(26, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(29, tIdx.y)][hook(28, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(31, tIdx.y)][hook(30, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(33, tIdx.y)][hook(32, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(35, tIdx.y)][hook(34, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y)][hook(15, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 2) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(21, tIdx.y + 2)][hook(36, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(23, tIdx.y + 2)][hook(37, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(25, tIdx.y + 2)][hook(38, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(27, tIdx.y + 2)][hook(39, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(29, tIdx.y + 2)][hook(40, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(31, tIdx.y + 2)][hook(41, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(33, tIdx.y + 2)][hook(42, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(35, tIdx.y + 2)][hook(43, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 2)][hook(17, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 2, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 2, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 4) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(21, tIdx.y + 4)][hook(44, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(23, tIdx.y + 4)][hook(45, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(25, tIdx.y + 4)][hook(46, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(27, tIdx.y + 4)][hook(47, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(29, tIdx.y + 4)][hook(48, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(31, tIdx.y + 4)][hook(49, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(33, tIdx.y + 4)][hook(50, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(35, tIdx.y + 4)][hook(51, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 4)][hook(18, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 4, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 4, z, DATA_W, DATA_H))];
  }

  if ((x < DATA_W) && ((y + 6) < DATA_H) && (z < DATA_D)) {
    float sum = 0.0f;

    sum += l_Volume[hook(11, tIdx.z + 0)][hook(21, tIdx.y + 6)][hook(52, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 8)];
    sum += l_Volume[hook(11, tIdx.z + 1)][hook(23, tIdx.y + 6)][hook(53, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 7)];
    sum += l_Volume[hook(11, tIdx.z + 2)][hook(25, tIdx.y + 6)][hook(54, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 6)];
    sum += l_Volume[hook(11, tIdx.z + 3)][hook(27, tIdx.y + 6)][hook(55, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 5)];
    sum += l_Volume[hook(11, tIdx.z + 4)][hook(29, tIdx.y + 6)][hook(56, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 4)];
    sum += l_Volume[hook(11, tIdx.z + 5)][hook(31, tIdx.y + 6)][hook(57, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 3)];
    sum += l_Volume[hook(11, tIdx.z + 6)][hook(33, tIdx.y + 6)][hook(58, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 2)];
    sum += l_Volume[hook(11, tIdx.z + 7)][hook(35, tIdx.y + 6)][hook(59, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 1)];
    sum += l_Volume[hook(11, tIdx.z + 8)][hook(16, tIdx.y + 6)][hook(19, tIdx.x)] * c_Smoothing_Filter_Z[hook(3, 0)];

    Filter_Response[hook(0, Calculate4DIndex(x, y + 6, z, t, DATA_W, DATA_H, DATA_D))] = sum / Smoothed_Certainty[hook(2, Calculate3DIndex(x, y + 6, z, DATA_W, DATA_H))];
  }
}