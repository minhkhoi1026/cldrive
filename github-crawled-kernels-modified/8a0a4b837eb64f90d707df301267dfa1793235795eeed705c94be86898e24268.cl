//{"Classifier_Performance":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"EPOCS":10,"Mask":2,"NUMBER_OF_VOLUMES":8,"Volume":11,"Volumes":1,"a":12,"b":13,"c_Correct_Classes":4,"c_d":3,"gradient":15,"n":9,"weights":14,"xs":16}
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

void ReadSphere(local float* Volume, global const float* Volumes, int x, int y, int z, int t, int3 tIdx, int DATA_W, int DATA_H, int DATA_D) {
  Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(11, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }
}

void normalize_x(global float* x_space, int N, int d);

float doFold(global float* dense_points, global int* trainIndex, global int* testIndex, int d, global float* alpha, constant float* c_Correct_Classes, int trainN, int numExemplos, global const float* kmatrix, int fold, int NperFold);

float dotproduct(global float* a, global float* b, int N) {
  float ret = 0;
  for (int k = 0; k < N; ++k) {
    ret += a[hook(12, k)] * b[hook(13, k)];
  }
  return ret;
}

kernel void CalculateStatisticalMapSearchlight_33(global float* Classifier_Performance, global const float* Volumes, global const float* Mask, constant float* c_d, constant float* c_Correct_Classes, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private float n, private int EPOCS)

{
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f) {
    Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    return;
  }

  if (((x + 2) >= DATA_W) || ((y + 2) >= DATA_H) || ((z + 2) >= DATA_D)) {
    Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    return;
  }

  if (((x - 2) < 0) || ((y - 2) < 0) || ((z - 2) < 0)) {
    Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    return;
  }

  int classification_performance = 0;

  float weights[34];

  int uncensoredVolumes = 0;

  for (int validation = 0; validation < NUMBER_OF_VOLUMES; validation++) {
    if (c_Correct_Classes[hook(4, validation)] == 9999.0f) {
      continue;
    }

    uncensoredVolumes++;

    weights[hook(14, 0)] = 0.0f;
    weights[hook(14, 1)] = 0.0f;
    weights[hook(14, 2)] = 0.0f;
    weights[hook(14, 3)] = 0.0f;
    weights[hook(14, 4)] = 0.0f;
    weights[hook(14, 5)] = 0.0f;
    weights[hook(14, 6)] = 0.0f;
    weights[hook(14, 7)] = 0.0f;
    weights[hook(14, 8)] = 0.0f;
    weights[hook(14, 9)] = 0.0f;
    weights[hook(14, 10)] = 0.0f;
    weights[hook(14, 11)] = 0.0f;
    weights[hook(14, 12)] = 0.0f;
    weights[hook(14, 13)] = 0.0f;
    weights[hook(14, 14)] = 0.0f;
    weights[hook(14, 15)] = 0.0f;
    weights[hook(14, 16)] = 0.0f;
    weights[hook(14, 17)] = 0.0f;
    weights[hook(14, 18)] = 0.0f;
    weights[hook(14, 19)] = 0.0f;
    weights[hook(14, 20)] = 0.0f;
    weights[hook(14, 21)] = 0.0f;
    weights[hook(14, 22)] = 0.0f;
    weights[hook(14, 23)] = 0.0f;
    weights[hook(14, 24)] = 0.0f;
    weights[hook(14, 25)] = 0.0f;
    weights[hook(14, 26)] = 0.0f;
    weights[hook(14, 27)] = 0.0f;
    weights[hook(14, 28)] = 0.0f;
    weights[hook(14, 29)] = 0.0f;
    weights[hook(14, 30)] = 0.0f;
    weights[hook(14, 31)] = 0.0f;
    weights[hook(14, 32)] = 0.0f;
    weights[hook(14, 33)] = 0.0f;

    for (int epoc = 0; epoc < EPOCS; epoc++) {
      float gradient[34];

      gradient[hook(15, 0)] = 0.0f;
      gradient[hook(15, 1)] = 0.0f;
      gradient[hook(15, 2)] = 0.0f;
      gradient[hook(15, 3)] = 0.0f;
      gradient[hook(15, 4)] = 0.0f;
      gradient[hook(15, 5)] = 0.0f;
      gradient[hook(15, 6)] = 0.0f;
      gradient[hook(15, 7)] = 0.0f;
      gradient[hook(15, 8)] = 0.0f;
      gradient[hook(15, 9)] = 0.0f;
      gradient[hook(15, 10)] = 0.0f;
      gradient[hook(15, 11)] = 0.0f;
      gradient[hook(15, 12)] = 0.0f;
      gradient[hook(15, 13)] = 0.0f;
      gradient[hook(15, 14)] = 0.0f;
      gradient[hook(15, 15)] = 0.0f;
      gradient[hook(15, 16)] = 0.0f;
      gradient[hook(15, 17)] = 0.0f;
      gradient[hook(15, 18)] = 0.0f;
      gradient[hook(15, 19)] = 0.0f;
      gradient[hook(15, 20)] = 0.0f;
      gradient[hook(15, 21)] = 0.0f;
      gradient[hook(15, 22)] = 0.0f;
      gradient[hook(15, 23)] = 0.0f;
      gradient[hook(15, 24)] = 0.0f;
      gradient[hook(15, 25)] = 0.0f;
      gradient[hook(15, 26)] = 0.0f;
      gradient[hook(15, 27)] = 0.0f;
      gradient[hook(15, 28)] = 0.0f;
      gradient[hook(15, 29)] = 0.0f;
      gradient[hook(15, 30)] = 0.0f;
      gradient[hook(15, 31)] = 0.0f;
      gradient[hook(15, 32)] = 0.0f;
      gradient[hook(15, 33)] = 0.0f;

      for (int t = 0; t < NUMBER_OF_VOLUMES; t++) {
        if ((t == validation) || (c_Correct_Classes[hook(4, t)] == 9999.0f)) {
          continue;
        }

        float s;
        s = weights[hook(14, 0)] * 1.0f;

        float x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33;
        x1 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z - 2, t, DATA_W, DATA_H, DATA_D))];
        x2 = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x3 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 0, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x4 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x5 = Volumes[hook(1, Calculate4DIndex(x + 0, y - 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x6 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x7 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x8 = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x9 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 0, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x10 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
        x11 = Volumes[hook(1, Calculate4DIndex(x - 2, y + 0, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x12 = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x13 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 0, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x14 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x15 = Volumes[hook(1, Calculate4DIndex(x + 0, y - 2, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x16 = Volumes[hook(1, Calculate4DIndex(x + 0, y - 1, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x17 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x18 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 1, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x19 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 2, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x20 = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x21 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 0, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x22 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x23 = Volumes[hook(1, Calculate4DIndex(x + 2, y + 0, z + 0, t, DATA_W, DATA_H, DATA_D))];
        x24 = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x25 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 0, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x26 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x27 = Volumes[hook(1, Calculate4DIndex(x + 0, y - 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x28 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x29 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x30 = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x31 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 0, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x32 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
        x33 = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z + 2, t, DATA_W, DATA_H, DATA_D))];

        s += weights[hook(14, 1)] * x1;
        s += weights[hook(14, 2)] * x2;
        s += weights[hook(14, 3)] * x3;
        s += weights[hook(14, 4)] * x4;
        s += weights[hook(14, 5)] * x5;
        s += weights[hook(14, 6)] * x6;
        s += weights[hook(14, 7)] * x7;
        s += weights[hook(14, 8)] * x8;
        s += weights[hook(14, 9)] * x9;
        s += weights[hook(14, 10)] * x10;
        s += weights[hook(14, 11)] * x11;
        s += weights[hook(14, 12)] * x12;
        s += weights[hook(14, 13)] * x13;
        s += weights[hook(14, 14)] * x14;
        s += weights[hook(14, 15)] * x15;
        s += weights[hook(14, 16)] * x16;
        s += weights[hook(14, 17)] * x17;
        s += weights[hook(14, 18)] * x18;
        s += weights[hook(14, 19)] * x19;
        s += weights[hook(14, 20)] * x20;
        s += weights[hook(14, 21)] * x21;
        s += weights[hook(14, 22)] * x22;
        s += weights[hook(14, 23)] * x23;
        s += weights[hook(14, 24)] * x24;
        s += weights[hook(14, 25)] * x25;
        s += weights[hook(14, 26)] * x26;
        s += weights[hook(14, 27)] * x27;
        s += weights[hook(14, 28)] * x28;
        s += weights[hook(14, 29)] * x29;
        s += weights[hook(14, 30)] * x30;
        s += weights[hook(14, 31)] * x31;
        s += weights[hook(14, 32)] * x32;
        s += weights[hook(14, 33)] * x33;

        gradient[hook(15, 0)] += (s - c_d[hook(3, t)]) * 1.0f;
        gradient[hook(15, 1)] += (s - c_d[hook(3, t)]) * x1;
        gradient[hook(15, 2)] += (s - c_d[hook(3, t)]) * x2;
        gradient[hook(15, 3)] += (s - c_d[hook(3, t)]) * x3;
        gradient[hook(15, 4)] += (s - c_d[hook(3, t)]) * x4;
        gradient[hook(15, 5)] += (s - c_d[hook(3, t)]) * x5;
        gradient[hook(15, 6)] += (s - c_d[hook(3, t)]) * x6;
        gradient[hook(15, 7)] += (s - c_d[hook(3, t)]) * x7;
        gradient[hook(15, 8)] += (s - c_d[hook(3, t)]) * x8;
        gradient[hook(15, 9)] += (s - c_d[hook(3, t)]) * x9;
        gradient[hook(15, 10)] += (s - c_d[hook(3, t)]) * x10;
        gradient[hook(15, 11)] += (s - c_d[hook(3, t)]) * x11;
        gradient[hook(15, 12)] += (s - c_d[hook(3, t)]) * x12;
        gradient[hook(15, 13)] += (s - c_d[hook(3, t)]) * x13;
        gradient[hook(15, 14)] += (s - c_d[hook(3, t)]) * x14;
        gradient[hook(15, 15)] += (s - c_d[hook(3, t)]) * x15;
        gradient[hook(15, 16)] += (s - c_d[hook(3, t)]) * x16;
        gradient[hook(15, 17)] += (s - c_d[hook(3, t)]) * x17;
        gradient[hook(15, 18)] += (s - c_d[hook(3, t)]) * x18;
        gradient[hook(15, 19)] += (s - c_d[hook(3, t)]) * x19;
        gradient[hook(15, 20)] += (s - c_d[hook(3, t)]) * x20;
        gradient[hook(15, 21)] += (s - c_d[hook(3, t)]) * x21;
        gradient[hook(15, 22)] += (s - c_d[hook(3, t)]) * x22;
        gradient[hook(15, 23)] += (s - c_d[hook(3, t)]) * x23;
        gradient[hook(15, 24)] += (s - c_d[hook(3, t)]) * x24;
        gradient[hook(15, 25)] += (s - c_d[hook(3, t)]) * x25;
        gradient[hook(15, 26)] += (s - c_d[hook(3, t)]) * x26;
        gradient[hook(15, 27)] += (s - c_d[hook(3, t)]) * x27;
        gradient[hook(15, 28)] += (s - c_d[hook(3, t)]) * x28;
        gradient[hook(15, 29)] += (s - c_d[hook(3, t)]) * x29;
        gradient[hook(15, 30)] += (s - c_d[hook(3, t)]) * x30;
        gradient[hook(15, 31)] += (s - c_d[hook(3, t)]) * x31;
        gradient[hook(15, 32)] += (s - c_d[hook(3, t)]) * x32;
        gradient[hook(15, 33)] += (s - c_d[hook(3, t)]) * x33;
      }

      weights[hook(14, 0)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 0)];
      weights[hook(14, 1)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 1)];
      weights[hook(14, 2)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 2)];
      weights[hook(14, 3)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 3)];
      weights[hook(14, 4)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 4)];
      weights[hook(14, 5)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 5)];
      weights[hook(14, 6)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 6)];
      weights[hook(14, 7)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 7)];
      weights[hook(14, 8)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 8)];
      weights[hook(14, 9)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 9)];
      weights[hook(14, 10)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 10)];
      weights[hook(14, 11)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 11)];
      weights[hook(14, 12)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 12)];
      weights[hook(14, 13)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 13)];
      weights[hook(14, 14)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 14)];
      weights[hook(14, 15)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 15)];
      weights[hook(14, 16)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 16)];
      weights[hook(14, 17)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 17)];
      weights[hook(14, 18)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 18)];
      weights[hook(14, 19)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 19)];
      weights[hook(14, 20)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 20)];
      weights[hook(14, 21)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 21)];
      weights[hook(14, 22)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 22)];
      weights[hook(14, 23)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 23)];
      weights[hook(14, 24)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 24)];
      weights[hook(14, 25)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 25)];
      weights[hook(14, 26)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 26)];
      weights[hook(14, 27)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 27)];
      weights[hook(14, 28)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 28)];
      weights[hook(14, 29)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 29)];
      weights[hook(14, 30)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 30)];
      weights[hook(14, 31)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 31)];
      weights[hook(14, 32)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 32)];
      weights[hook(14, 33)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(15, 33)];
    }

    float s;
    s = weights[hook(14, 0)] * 1.0f;

    float xs[34];
    xs[hook(16, 1)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z - 2, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 2)] = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 3)] = Volumes[hook(1, Calculate4DIndex(x - 1, y + 0, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 4)] = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 5)] = Volumes[hook(1, Calculate4DIndex(x + 0, y - 1, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 6)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 7)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 1, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 8)] = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 9)] = Volumes[hook(1, Calculate4DIndex(x + 1, y + 0, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 10)] = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z - 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 11)] = Volumes[hook(1, Calculate4DIndex(x - 2, y + 0, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 12)] = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 13)] = Volumes[hook(1, Calculate4DIndex(x - 1, y + 0, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 14)] = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 15)] = Volumes[hook(1, Calculate4DIndex(x + 0, y - 2, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 16)] = Volumes[hook(1, Calculate4DIndex(x + 0, y - 1, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 17)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 18)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 1, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 19)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 2, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 20)] = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 21)] = Volumes[hook(1, Calculate4DIndex(x + 1, y + 0, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 22)] = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 23)] = Volumes[hook(1, Calculate4DIndex(x + 2, y + 0, z + 0, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 24)] = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 25)] = Volumes[hook(1, Calculate4DIndex(x - 1, y + 0, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 26)] = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 27)] = Volumes[hook(1, Calculate4DIndex(x + 0, y - 1, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 28)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 29)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 1, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 30)] = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 31)] = Volumes[hook(1, Calculate4DIndex(x + 1, y + 0, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 32)] = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z + 1, validation, DATA_W, DATA_H, DATA_D))];
    xs[hook(16, 33)] = Volumes[hook(1, Calculate4DIndex(x + 0, y + 0, z + 2, validation, DATA_W, DATA_H, DATA_D))];

    if (x == 9 && y == 22 && z == 26) {
    }

    s += weights[hook(14, 1)] * xs[hook(16, 1)];
    s += weights[hook(14, 2)] * xs[hook(16, 2)];
    s += weights[hook(14, 3)] * xs[hook(16, 3)];
    s += weights[hook(14, 4)] * xs[hook(16, 4)];
    s += weights[hook(14, 5)] * xs[hook(16, 5)];
    s += weights[hook(14, 6)] * xs[hook(16, 6)];
    s += weights[hook(14, 7)] * xs[hook(16, 7)];
    s += weights[hook(14, 8)] * xs[hook(16, 8)];
    s += weights[hook(14, 9)] * xs[hook(16, 9)];
    s += weights[hook(14, 10)] * xs[hook(16, 10)];
    s += weights[hook(14, 11)] * xs[hook(16, 11)];
    s += weights[hook(14, 12)] * xs[hook(16, 12)];
    s += weights[hook(14, 13)] * xs[hook(16, 13)];
    s += weights[hook(14, 14)] * xs[hook(16, 14)];
    s += weights[hook(14, 15)] * xs[hook(16, 15)];
    s += weights[hook(14, 16)] * xs[hook(16, 16)];
    s += weights[hook(14, 17)] * xs[hook(16, 17)];
    s += weights[hook(14, 18)] * xs[hook(16, 18)];
    s += weights[hook(14, 19)] * xs[hook(16, 19)];
    s += weights[hook(14, 20)] * xs[hook(16, 20)];
    s += weights[hook(14, 21)] * xs[hook(16, 21)];
    s += weights[hook(14, 22)] * xs[hook(16, 22)];
    s += weights[hook(14, 23)] * xs[hook(16, 23)];
    s += weights[hook(14, 24)] * xs[hook(16, 24)];
    s += weights[hook(14, 25)] * xs[hook(16, 25)];
    s += weights[hook(14, 26)] * xs[hook(16, 26)];
    s += weights[hook(14, 27)] * xs[hook(16, 27)];
    s += weights[hook(14, 28)] * xs[hook(16, 28)];
    s += weights[hook(14, 29)] * xs[hook(16, 29)];
    s += weights[hook(14, 30)] * xs[hook(16, 30)];
    s += weights[hook(14, 31)] * xs[hook(16, 31)];
    s += weights[hook(14, 32)] * xs[hook(16, 32)];
    s += weights[hook(14, 33)] * xs[hook(16, 33)];

    float classification;
    if (s > 0.0f) {
      classification = 0.0f;
    } else {
      classification = 1.0f;
    }

    if (classification == c_Correct_Classes[hook(4, validation)]) {
      classification_performance++;
    }
  }

  Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = (float)classification_performance / (float)uncensoredVolumes;
}