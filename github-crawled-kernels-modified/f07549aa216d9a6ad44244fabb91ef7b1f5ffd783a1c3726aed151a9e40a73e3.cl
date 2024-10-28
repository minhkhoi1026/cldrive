//{"DATA_D":22,"DATA_H":21,"DATA_W":20,"FILTER":23,"a11":0,"a12":1,"a13":2,"a22":3,"a23":4,"a33":5,"c_Filter_Directions_X":17,"c_Filter_Directions_Y":18,"c_Filter_Directions_Z":19,"h1":6,"h2":7,"h3":8,"q1":9,"q2":10,"t11":11,"t12":12,"t13":13,"t22":14,"t23":15,"t33":16}
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

kernel void CalculateAMatricesAndHVectors(global float* a11, global float* a12, global float* a13, global float* a22, global float* a23, global float* a33, global float* h1, global float* h2, global float* h3, global const float2* q1, global const float2* q2, global const float* t11, global const float* t12, global const float* t13, global const float* t22, global const float* t23, global const float* t33, constant float* c_Filter_Directions_X, constant float* c_Filter_Directions_Y, constant float* c_Filter_Directions_Z, private int DATA_W, private int DATA_H, private int DATA_D, private int FILTER) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if ((x >= DATA_W) || (y >= DATA_H) || (z >= DATA_D))
    return;

  int idx = x + y * DATA_W + z * DATA_W * DATA_H;

  float2 q1_ = q1[hook(9, idx)];
  float2 q2_ = q2[hook(10, idx)];

  float qqReal = q1_.x * q2_.x + q1_.y * q2_.y;
  float qqImag = -q1_.x * q2_.y + q1_.y * q2_.x;
  float phase_difference = atan2(qqImag, qqReal);
  float Aqq = sqrt(qqReal * qqReal + qqImag * qqImag);
  float certainty = sqrt(Aqq) * cos(phase_difference / 2.0f) * cos(phase_difference / 2.0f);

  float tt11, tt12, tt13, tt22, tt23, tt33;

  tt11 = t11[hook(11, idx)] * t11[hook(11, idx)] + t12[hook(12, idx)] * t12[hook(12, idx)] + t13[hook(13, idx)] * t13[hook(13, idx)];
  tt12 = t11[hook(11, idx)] * t12[hook(12, idx)] + t12[hook(12, idx)] * t22[hook(14, idx)] + t13[hook(13, idx)] * t23[hook(15, idx)];
  tt13 = t11[hook(11, idx)] * t13[hook(13, idx)] + t12[hook(12, idx)] * t23[hook(15, idx)] + t13[hook(13, idx)] * t33[hook(16, idx)];
  tt22 = t12[hook(12, idx)] * t12[hook(12, idx)] + t22[hook(14, idx)] * t22[hook(14, idx)] + t23[hook(15, idx)] * t23[hook(15, idx)];
  tt23 = t12[hook(12, idx)] * t13[hook(13, idx)] + t22[hook(14, idx)] * t23[hook(15, idx)] + t23[hook(15, idx)] * t33[hook(16, idx)];
  tt33 = t13[hook(13, idx)] * t13[hook(13, idx)] + t23[hook(15, idx)] * t23[hook(15, idx)] + t33[hook(16, idx)] * t33[hook(16, idx)];

  a11[hook(0, idx)] += certainty * tt11;
  a12[hook(1, idx)] += certainty * tt12;
  a13[hook(2, idx)] += certainty * tt13;
  a22[hook(3, idx)] += certainty * tt22;
  a23[hook(4, idx)] += certainty * tt23;
  a33[hook(5, idx)] += certainty * tt33;

  h1[hook(6, idx)] += certainty * phase_difference * (c_Filter_Directions_X[hook(17, FILTER)] * tt11 + c_Filter_Directions_Y[hook(18, FILTER)] * tt12 + c_Filter_Directions_Z[hook(19, FILTER)] * tt13);
  h2[hook(7, idx)] += certainty * phase_difference * (c_Filter_Directions_X[hook(17, FILTER)] * tt12 + c_Filter_Directions_Y[hook(18, FILTER)] * tt22 + c_Filter_Directions_Z[hook(19, FILTER)] * tt23);
  h3[hook(8, idx)] += certainty * phase_difference * (c_Filter_Directions_X[hook(17, FILTER)] * tt13 + c_Filter_Directions_Y[hook(18, FILTER)] * tt23 + c_Filter_Directions_Z[hook(19, FILTER)] * tt33);
}