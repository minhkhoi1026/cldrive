//{"DATA_D":5,"DATA_H":4,"DATA_W":3,"Original_Volume":1,"VOLUME":6,"Volume":0,"c_Parameter_Vector":2}
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

kernel void InterpolateVolumeNearestLinear(global float* Volume, read_only image3d_t Original_Volume, constant float* c_Parameter_Vector, private int DATA_W, private int DATA_H, private int DATA_D, private int VOLUME) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  int idx = Calculate4DIndex(x, y, z, VOLUME, DATA_W, DATA_H, DATA_D);
  float4 Motion_Vector;
  float xf, yf, zf;

  xf = (float)x - ((float)DATA_W - 1.0f) * 0.5f;
  yf = (float)y - ((float)DATA_H - 1.0f) * 0.5f;
  zf = (float)z - ((float)DATA_D - 1.0f) * 0.5f;

  Motion_Vector.x = x + c_Parameter_Vector[hook(2, 0)] + c_Parameter_Vector[hook(2, 3)] * xf + c_Parameter_Vector[hook(2, 4)] * yf + c_Parameter_Vector[hook(2, 5)] * zf + 0.5f;
  Motion_Vector.y = y + c_Parameter_Vector[hook(2, 1)] + c_Parameter_Vector[hook(2, 6)] * xf + c_Parameter_Vector[hook(2, 7)] * yf + c_Parameter_Vector[hook(2, 8)] * zf + 0.5f;
  Motion_Vector.z = z + c_Parameter_Vector[hook(2, 2)] + c_Parameter_Vector[hook(2, 9)] * xf + c_Parameter_Vector[hook(2, 10)] * yf + c_Parameter_Vector[hook(2, 11)] * zf + 0.5f;
  Motion_Vector.w = 0.0f;

  float4 Interpolated_Value = read_imagef(Original_Volume, volume_sampler_nearest, Motion_Vector);
  Volume[hook(0, idx)] = Interpolated_Value.x;
}