//{"DATA_D":5,"DATA_H":4,"DATA_W":3,"Phase_Gradients":0,"q13":1,"q23":2}
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

kernel void CalculatePhaseGradientsZ(global float* Phase_Gradients, global const float2* q13, global const float2* q23, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if ((x >= DATA_W) || (y >= DATA_H) || (z >= DATA_D) || ((z + 1) >= DATA_D) || ((z - 1) < 0))
    return;

  float total_complex_product_real, total_complex_product_imag;
  float2 a, c;
  int idx_minus_1, idx_plus_1, idx;

  idx = Calculate3DIndex(x, y, z, DATA_W, DATA_H);

  idx_plus_1 = Calculate3DIndex(x, y, z + 1, DATA_W, DATA_H);
  idx_minus_1 = Calculate3DIndex(x, y, z - 1, DATA_W, DATA_H);

  total_complex_product_real = 0.0f;
  total_complex_product_imag = 0.0f;

  a = q13[hook(1, idx_plus_1)];
  c = q13[hook(1, idx)];

  total_complex_product_real += a.x * c.x + a.y * c.y;
  total_complex_product_imag += a.y * c.x - a.x * c.y;

  a.x = c.x;
  a.y = c.y;
  c = q13[hook(1, idx_minus_1)];

  total_complex_product_real += a.x * c.x + a.y * c.y;
  total_complex_product_imag += a.y * c.x - a.x * c.y;

  a = q23[hook(2, idx_plus_1)];
  c = q23[hook(2, idx)];

  total_complex_product_real += a.x * c.x + a.y * c.y;
  total_complex_product_imag += a.y * c.x - a.x * c.y;

  a.x = c.x;
  a.y = c.y;
  c = q23[hook(2, idx_minus_1)];

  total_complex_product_real += a.x * c.x + a.y * c.y;
  total_complex_product_imag += a.y * c.x - a.x * c.y;

  Phase_Gradients[hook(0, idx)] = atan2(total_complex_product_imag, total_complex_product_real);
}