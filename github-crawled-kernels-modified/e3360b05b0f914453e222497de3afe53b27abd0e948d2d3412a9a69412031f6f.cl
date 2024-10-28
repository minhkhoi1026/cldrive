//{"DATA_D":14,"DATA_H":13,"DATA_W":12,"DisplacementX":0,"DisplacementY":1,"DisplacementZ":2,"a11":3,"a12":4,"a13":5,"a22":6,"a23":7,"a33":8,"h1":9,"h2":10,"h3":11}
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

kernel void CalculateDisplacementUpdate(global float* DisplacementX, global float* DisplacementY, global float* DisplacementZ, global const float* a11, global const float* a12, global const float* a13, global const float* a22, global const float* a23, global const float* a33, global const float* h1, global const float* h2, global const float* h3, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if ((x >= DATA_W) || (y >= DATA_H) || (z >= DATA_D))
    return;

  int idx = x + y * DATA_W + z * DATA_W * DATA_H;

  float a11Temp = a11[hook(3, idx)];
  float a12Temp = a12[hook(4, idx)];
  float a13Temp = a13[hook(5, idx)];
  float a22Temp = a22[hook(6, idx)];
  float a23Temp = a23[hook(7, idx)];
  float a33Temp = a33[hook(8, idx)];
  float h1Temp = h1[hook(9, idx)];
  float h2Temp = h2[hook(10, idx)];
  float h3Temp = h3[hook(11, idx)];

  float norm = 1.0f / (a11Temp * a22Temp * a33Temp - a11Temp * a23Temp * a23Temp - a12Temp * a12Temp * a33Temp + a12Temp * a23Temp * a13Temp + a13Temp * a12Temp * a23Temp - a13Temp * a22Temp * a13Temp + 1E-16f);

  DisplacementX[hook(0, idx)] = norm * ((h3Temp * (a12Temp * a23Temp - a13Temp * a22Temp)) - (h2Temp * (a12Temp * a33Temp - a13Temp * a23Temp)) + (h1Temp * (a22Temp * a33Temp - a23Temp * a23Temp)));
  DisplacementY[hook(1, idx)] = norm * ((h2Temp * (a11Temp * a33Temp - a13Temp * a13Temp)) - (h3Temp * (a11Temp * a23Temp - a13Temp * a12Temp)) - (h1Temp * (a12Temp * a33Temp - a23Temp * a13Temp)));
  DisplacementZ[hook(2, idx)] = norm * ((h3Temp * (a11Temp * a22Temp - a12Temp * a12Temp)) - (h2Temp * (a11Temp * a23Temp - a12Temp * a13Temp)) + (h1Temp * (a12Temp * a23Temp - a22Temp * a13Temp)));
}