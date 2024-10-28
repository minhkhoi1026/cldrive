//{"DATA_D":7,"DATA_H":6,"DATA_W":5,"Original_Volume":1,"VOXEL_DIFFERENCE_X":2,"VOXEL_DIFFERENCE_Y":3,"VOXEL_DIFFERENCE_Z":4,"Volume":0}
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

kernel void RescaleVolumeCubic(global float* Volume, read_only image3d_t Original_Volume, private float VOXEL_DIFFERENCE_X, private float VOXEL_DIFFERENCE_Y, private float VOXEL_DIFFERENCE_Z, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  int idx = Calculate3DIndex(x, y, z, DATA_W, DATA_H);
  float3 Motion_Vector;

  Motion_Vector.x = x * VOXEL_DIFFERENCE_X + 0.5f;
  Motion_Vector.y = y * VOXEL_DIFFERENCE_Y + 0.5f;
  Motion_Vector.z = z * VOXEL_DIFFERENCE_Z + 0.5f;

  const float3 coord_grid = Motion_Vector - 0.5f;
  float3 index = floor(coord_grid);
  const float3 fraction = coord_grid - index;
  index = index + 0.5f;

  float result;

  for (float z = -1.0f; z < 2.5f; z += 1.0f) {
    float bsplineZ = bspline(z - fraction.z);
    float w = index.z + z;
    for (float y = -1.0f; y < 2.5f; y += 1.0f) {
      float bsplineYZ = bspline(y - fraction.y) * bsplineZ;
      float v = index.y + y;
      for (float x = -1.0f; x < 2.5f; x += 1.0f) {
        float bsplineXYZ = bspline(x - fraction.x) * bsplineYZ;
        float u = index.x + x;
        float4 vector;
        vector.x = u;
        vector.y = v;
        vector.z = w;
        vector.w = 0.0f;
        float4 temp = read_imagef(Original_Volume, volume_sampler_linear, vector);
        result += bsplineXYZ * temp.x;
      }
    }
  }

  Volume[hook(0, idx)] = result;
}