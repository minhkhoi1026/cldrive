//{"Classifier_Performance":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"EPOCS":10,"Mask":2,"NUMBER_OF_VOLUMES":8,"Volume":11,"Volumes":1,"a":12,"b":13,"c_Correct_Classes":4,"c_d":3,"gradient":15,"n":9,"weights":14}
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

kernel void CalculateStatisticalMapSearchlight___(global float* Classifier_Performance, global const float* Volumes, global const float* Mask, constant float* c_d, constant float* c_Correct_Classes, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES,

                                                  private float n, private int EPOCS)

{
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f) {
    Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    return;
  }

  if (((x + 1) >= DATA_W) || ((y + 1) >= DATA_H) || ((z + 1) >= DATA_D)) {
    Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    return;
  }

  if (((x - 1) < 0) || ((y - 1) < 0) || ((z - 1) < 0)) {
    Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    return;
  }

  int classification_performance = 0;

  float weights[20];

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

  for (int epoc = 0; epoc < EPOCS; epoc++) {
    float gradient[20];

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

    for (int t = 0; t < NUMBER_OF_VOLUMES / 2; t++) {
      if (c_Correct_Classes[hook(4, t)] == 9999.0f) {
        continue;
      }

      float s;
      s = weights[hook(14, 0)] * 1.0f;

      float x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19;

      x1 = Volumes[hook(1, Calculate4DIndex(x - 1, y, z - 1, t, DATA_W, DATA_H, DATA_D))];
      x2 = Volumes[hook(1, Calculate4DIndex(x, y - 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
      x3 = Volumes[hook(1, Calculate4DIndex(x, y, z - 1, t, DATA_W, DATA_H, DATA_D))];
      x4 = Volumes[hook(1, Calculate4DIndex(x, y + 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
      x5 = Volumes[hook(1, Calculate4DIndex(x + 1, y, z - 1, t, DATA_W, DATA_H, DATA_D))];

      x6 = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z, t, DATA_W, DATA_H, DATA_D))];
      x7 = Volumes[hook(1, Calculate4DIndex(x - 1, y, z, t, DATA_W, DATA_H, DATA_D))];
      x8 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z, t, DATA_W, DATA_H, DATA_D))];
      x9 = Volumes[hook(1, Calculate4DIndex(x, y - 1, z, t, DATA_W, DATA_H, DATA_D))];
      x10 = Volumes[hook(1, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))];
      x11 = Volumes[hook(1, Calculate4DIndex(x, y + 1, z, t, DATA_W, DATA_H, DATA_D))];
      x12 = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z, t, DATA_W, DATA_H, DATA_D))];
      x13 = Volumes[hook(1, Calculate4DIndex(x + 1, y, z, t, DATA_W, DATA_H, DATA_D))];
      x14 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z, t, DATA_W, DATA_H, DATA_D))];

      x15 = Volumes[hook(1, Calculate4DIndex(x - 1, y, z + 1, t, DATA_W, DATA_H, DATA_D))];
      x16 = Volumes[hook(1, Calculate4DIndex(x, y - 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
      x17 = Volumes[hook(1, Calculate4DIndex(x, y, z + 1, t, DATA_W, DATA_H, DATA_D))];
      x18 = Volumes[hook(1, Calculate4DIndex(x, y + 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
      x19 = Volumes[hook(1, Calculate4DIndex(x + 1, y, z + 1, t, DATA_W, DATA_H, DATA_D))];

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
  }

  float s;

  int uncensoredVolumes = 0;

  for (int t = NUMBER_OF_VOLUMES / 2 + 1; t < NUMBER_OF_VOLUMES; t++) {
    if (c_Correct_Classes[hook(4, t)] == 9999.0f) {
      continue;
    }

    uncensoredVolumes++;

    s = weights[hook(14, 0)] * 1.0f;

    float x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19;

    x1 = Volumes[hook(1, Calculate4DIndex(x - 1, y, z - 1, t, DATA_W, DATA_H, DATA_D))];
    x2 = Volumes[hook(1, Calculate4DIndex(x, y - 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
    x3 = Volumes[hook(1, Calculate4DIndex(x, y, z - 1, t, DATA_W, DATA_H, DATA_D))];
    x4 = Volumes[hook(1, Calculate4DIndex(x, y + 1, z - 1, t, DATA_W, DATA_H, DATA_D))];
    x5 = Volumes[hook(1, Calculate4DIndex(x + 1, y, z - 1, t, DATA_W, DATA_H, DATA_D))];

    x6 = Volumes[hook(1, Calculate4DIndex(x - 1, y - 1, z, t, DATA_W, DATA_H, DATA_D))];
    x7 = Volumes[hook(1, Calculate4DIndex(x - 1, y, z, t, DATA_W, DATA_H, DATA_D))];
    x8 = Volumes[hook(1, Calculate4DIndex(x - 1, y + 1, z, t, DATA_W, DATA_H, DATA_D))];
    x9 = Volumes[hook(1, Calculate4DIndex(x, y - 1, z, t, DATA_W, DATA_H, DATA_D))];
    x10 = Volumes[hook(1, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))];

    x11 = Volumes[hook(1, Calculate4DIndex(x, y + 1, z, t, DATA_W, DATA_H, DATA_D))];
    x12 = Volumes[hook(1, Calculate4DIndex(x + 1, y - 1, z, t, DATA_W, DATA_H, DATA_D))];
    x13 = Volumes[hook(1, Calculate4DIndex(x + 1, y, z, t, DATA_W, DATA_H, DATA_D))];
    x14 = Volumes[hook(1, Calculate4DIndex(x + 1, y + 1, z, t, DATA_W, DATA_H, DATA_D))];

    x15 = Volumes[hook(1, Calculate4DIndex(x - 1, y, z + 1, t, DATA_W, DATA_H, DATA_D))];
    x16 = Volumes[hook(1, Calculate4DIndex(x, y - 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
    x17 = Volumes[hook(1, Calculate4DIndex(x, y, z + 1, t, DATA_W, DATA_H, DATA_D))];
    x18 = Volumes[hook(1, Calculate4DIndex(x, y + 1, z + 1, t, DATA_W, DATA_H, DATA_D))];
    x19 = Volumes[hook(1, Calculate4DIndex(x + 1, y, z + 1, t, DATA_W, DATA_H, DATA_D))];

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

    float classification;
    if (s > 0.0f) {
      classification = 0.0f;
    } else {
      classification = 1.0f;
    }

    if (classification == c_Correct_Classes[hook(4, t)]) {
      classification_performance++;
    }
  }

  Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = (float)classification_performance / (float)uncensoredVolumes;
}