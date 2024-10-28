//{"EPI_DATA_D_INTERPOLATED":7,"EPI_DATA_H_INTERPOLATED":6,"EPI_DATA_W_INTERPOLATED":5,"Interpolated_EPI_Volume":1,"MM_EPI_Z_CUT":11,"T1_DATA_D":4,"T1_DATA_H":3,"T1_DATA_W":2,"T1_EPI_Volume":0,"T1_VOXEL_SIZE_Z":12,"x_diff":8,"y_diff":9,"z_diff":10}
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

constant sampler_t volume_sampler_nearest = 0 | 2 | 0x10;

constant sampler_t volume_sampler_linear = 0 | 2 | 0x20;

float myabs(float value) {
  if (value < 0.0f)
    return -value;
  else
    return value;
}

float bspline(float t) {
  t = fabs(t);
  const float a = 2.0f - t;

  if (t < 1.0f)
    return 2.0f / 3.0f - 0.5f * t * t * a;
  else if (t < 2.0f)
    return a * a * a / 6.0f;
  else
    return 0.0f;
}

kernel void CopyEPIVolumeToT1(global float* T1_EPI_Volume, global float* Interpolated_EPI_Volume, private int T1_DATA_W, private int T1_DATA_H, private int T1_DATA_D, private int EPI_DATA_W_INTERPOLATED, private int EPI_DATA_H_INTERPOLATED, private int EPI_DATA_D_INTERPOLATED, private int x_diff, private int y_diff, private int z_diff, private int MM_EPI_Z_CUT, private float T1_VOXEL_SIZE_Z) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int T1_EPI_idx, Interpolated_EPI_idx;
  int x_T1, x_Interpolated;
  int y_T1, y_Interpolated;
  int z_T1, z_Interpolated;

  if (x_diff > 0) {
    x_T1 = x;
    x_Interpolated = x + (int)round((float)x_diff / 2.0);
  }

  else {
    x_T1 = x + (int)round((float)abs(x_diff) / 2.0);
    x_Interpolated = x;
  }

  if (y_diff > 0) {
    y_T1 = y;
    y_Interpolated = y + (int)round((float)y_diff / 2.0);
  }

  else {
    y_T1 = y + (int)round((float)abs(y_diff) / 2.0);
    y_Interpolated = y;
  }

  if (z_diff > 0) {
    z_T1 = z;
    z_Interpolated = z + (int)round((float)z_diff / 2.0) + (int)round((float)MM_EPI_Z_CUT / T1_VOXEL_SIZE_Z);
  }

  else {
    z_T1 = z + (int)round((float)abs(z_diff) / 2.0);
    z_Interpolated = z + (int)round((float)MM_EPI_Z_CUT / T1_VOXEL_SIZE_Z);
  }

  if ((x_Interpolated >= EPI_DATA_W_INTERPOLATED) || (y_Interpolated >= EPI_DATA_H_INTERPOLATED) || (z_Interpolated >= EPI_DATA_D_INTERPOLATED) || (x_T1 >= T1_DATA_W) || (y_T1 >= T1_DATA_H) || (z_T1 >= T1_DATA_D)) {
    return;
  } else if ((x_Interpolated < 0) || (y_Interpolated < 0) || (z_Interpolated < 0) || (x_T1 < 0) || (y_T1 < 0) || (z_T1 < 0)) {
    return;
  } else {
    T1_EPI_idx = Calculate3DIndex(x_T1, y_T1, z_T1, T1_DATA_W, T1_DATA_H);
    Interpolated_EPI_idx = Calculate3DIndex(x_Interpolated, y_Interpolated, z_Interpolated, EPI_DATA_W_INTERPOLATED, EPI_DATA_H_INTERPOLATED);
    T1_EPI_Volume[hook(0, T1_EPI_idx)] = Interpolated_EPI_Volume[hook(1, Interpolated_EPI_idx)];
  }
}