//{"DATA_D":6,"DATA_H":5,"DATA_W":4,"c_Parameter_Vector":3,"d_Displacement_Field_X":0,"d_Displacement_Field_Y":1,"d_Displacement_Field_Z":2}
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

kernel void AddLinearAndNonLinearDisplacement(global float* d_Displacement_Field_X, global float* d_Displacement_Field_Y, global float* d_Displacement_Field_Z, constant float* c_Parameter_Vector, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if ((x >= DATA_W) || (y >= DATA_H) || (z >= DATA_D))
    return;

  int idx = Calculate3DIndex(x, y, z, DATA_W, DATA_H);
  float4 Motion_Vector;
  float xf, yf, zf;

  xf = (float)x - ((float)DATA_W - 1.0f) * 0.5f;
  yf = (float)y - ((float)DATA_H - 1.0f) * 0.5f;
  zf = (float)z - ((float)DATA_D - 1.0f) * 0.5f;

  Motion_Vector.x = c_Parameter_Vector[hook(3, 0)] + c_Parameter_Vector[hook(3, 3)] * xf + c_Parameter_Vector[hook(3, 4)] * yf + c_Parameter_Vector[hook(3, 5)] * zf;
  Motion_Vector.y = c_Parameter_Vector[hook(3, 1)] + c_Parameter_Vector[hook(3, 6)] * xf + c_Parameter_Vector[hook(3, 7)] * yf + c_Parameter_Vector[hook(3, 8)] * zf;
  Motion_Vector.z = c_Parameter_Vector[hook(3, 2)] + c_Parameter_Vector[hook(3, 9)] * xf + c_Parameter_Vector[hook(3, 10)] * yf + c_Parameter_Vector[hook(3, 11)] * zf;
  Motion_Vector.w = 0.0f;

  d_Displacement_Field_X[hook(0, idx)] += Motion_Vector.x;
  d_Displacement_Field_Y[hook(1, idx)] += Motion_Vector.y;
  d_Displacement_Field_Z[hook(2, idx)] += Motion_Vector.z;
}