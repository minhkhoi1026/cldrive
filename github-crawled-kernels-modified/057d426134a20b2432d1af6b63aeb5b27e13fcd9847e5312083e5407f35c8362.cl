//{"Classifier_Performance":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"EPOCS":10,"Mask":2,"NUMBER_OF_VOLUMES":8,"Volume":11,"Volumes":1,"c_Correct_Classes":4,"c_d":3,"gradient":13,"l_Volume":16,"l_Volume[tIdx.z + 4 + 1]":24,"l_Volume[tIdx.z + 4 + 1][tIdx.y + 4 + 1]":26,"l_Volume[tIdx.z + 4 + 1][tIdx.y + 4 - 1]":25,"l_Volume[tIdx.z + 4 + 1][tIdx.y + 4]":23,"l_Volume[tIdx.z + 4 - 1]":15,"l_Volume[tIdx.z + 4 - 1][tIdx.y + 4 + 1]":18,"l_Volume[tIdx.z + 4 - 1][tIdx.y + 4 - 1]":17,"l_Volume[tIdx.z + 4 - 1][tIdx.y + 4]":14,"l_Volume[tIdx.z + 4]":20,"l_Volume[tIdx.z + 4][tIdx.y + 4 + 1]":22,"l_Volume[tIdx.z + 4][tIdx.y + 4 - 1]":19,"l_Volume[tIdx.z + 4][tIdx.y + 4]":21,"n":9,"weights":12}
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

kernel void CalculateStatisticalMapSearchlight_(global float* Classifier_Performance, global const float* Volumes, global const float* Mask, constant float* c_d, constant float* c_Correct_Classes, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private float n, private int EPOCS)

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

  local float l_Volume[16][16][16];

  int classification_performance = 0;

  for (int validation = 0; validation < NUMBER_OF_VOLUMES; validation++) {
    float weights[20];

    weights[hook(12, 0)] = 0.0f;
    weights[hook(12, 1)] = 0.0f;
    weights[hook(12, 2)] = 0.0f;
    weights[hook(12, 3)] = 0.0f;
    weights[hook(12, 4)] = 0.0f;
    weights[hook(12, 5)] = 0.0f;
    weights[hook(12, 6)] = 0.0f;
    weights[hook(12, 7)] = 0.0f;
    weights[hook(12, 8)] = 0.0f;
    weights[hook(12, 9)] = 0.0f;
    weights[hook(12, 10)] = 0.0f;
    weights[hook(12, 11)] = 0.0f;
    weights[hook(12, 12)] = 0.0f;
    weights[hook(12, 13)] = 0.0f;
    weights[hook(12, 14)] = 0.0f;
    weights[hook(12, 15)] = 0.0f;
    weights[hook(12, 16)] = 0.0f;
    weights[hook(12, 17)] = 0.0f;
    weights[hook(12, 18)] = 0.0f;
    weights[hook(12, 19)] = 0.0f;

    for (int epoc = 0; epoc < EPOCS; epoc++) {
      float gradient[20];

      gradient[hook(13, 0)] = 0.0f;
      gradient[hook(13, 1)] = 0.0f;
      gradient[hook(13, 2)] = 0.0f;
      gradient[hook(13, 3)] = 0.0f;
      gradient[hook(13, 4)] = 0.0f;
      gradient[hook(13, 5)] = 0.0f;
      gradient[hook(13, 6)] = 0.0f;
      gradient[hook(13, 7)] = 0.0f;
      gradient[hook(13, 8)] = 0.0f;
      gradient[hook(13, 9)] = 0.0f;
      gradient[hook(13, 10)] = 0.0f;
      gradient[hook(13, 11)] = 0.0f;
      gradient[hook(13, 12)] = 0.0f;
      gradient[hook(13, 13)] = 0.0f;
      gradient[hook(13, 14)] = 0.0f;
      gradient[hook(13, 15)] = 0.0f;
      gradient[hook(13, 16)] = 0.0f;
      gradient[hook(13, 17)] = 0.0f;
      gradient[hook(13, 18)] = 0.0f;
      gradient[hook(13, 19)] = 0.0f;

      for (int t = 0; t < NUMBER_OF_VOLUMES; t++) {
        if (t == validation) {
          continue;
        }

        float s;

        ReadSphere((local float*)l_Volume, Volumes, x, y, z, t, tIdx, DATA_W, DATA_H, DATA_D);

        barrier(0x01);

        s = weights[hook(12, 0)] * 1.0f;

        s += weights[hook(12, 1)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4 - 1)];
        s += weights[hook(12, 2)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4 - 1)][hook(17, tIdx.x + 4)];
        s += weights[hook(12, 3)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4)];
        s += weights[hook(12, 4)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4 + 1)][hook(18, tIdx.x + 4)];
        s += weights[hook(12, 5)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4 + 1)];

        s += weights[hook(12, 6)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4 - 1)];
        s += weights[hook(12, 7)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4)];
        s += weights[hook(12, 8)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4 + 1)];
        s += weights[hook(12, 9)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4 - 1)];
        s += weights[hook(12, 10)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4)];
        s += weights[hook(12, 11)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4 + 1)];
        s += weights[hook(12, 12)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4 - 1)];
        s += weights[hook(12, 13)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4)];
        s += weights[hook(12, 14)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4 + 1)];

        s += weights[hook(12, 15)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4 - 1)];
        s += weights[hook(12, 16)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4 - 1)][hook(25, tIdx.x + 4)];
        s += weights[hook(12, 17)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4)];
        s += weights[hook(12, 18)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4 + 1)][hook(26, tIdx.x + 4)];
        s += weights[hook(12, 19)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4 + 1)];

        gradient[hook(13, 0)] += (s - c_d[hook(3, t)]) * 1.0f;

        gradient[hook(13, 1)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4 - 1)];
        gradient[hook(13, 2)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4 - 1)][hook(17, tIdx.x + 4)];
        gradient[hook(13, 3)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4)];
        gradient[hook(13, 4)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4 + 1)][hook(18, tIdx.x + 4)];
        gradient[hook(13, 5)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4 + 1)];

        gradient[hook(13, 6)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4 - 1)];
        gradient[hook(13, 7)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4)];
        gradient[hook(13, 8)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4 + 1)];
        gradient[hook(13, 9)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4 - 1)];
        gradient[hook(13, 10)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4)];
        gradient[hook(13, 11)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4 + 1)];
        gradient[hook(13, 12)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4 - 1)];
        gradient[hook(13, 13)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4)];
        gradient[hook(13, 14)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4 + 1)];

        gradient[hook(13, 15)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4 - 1)];
        gradient[hook(13, 16)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4 - 1)][hook(25, tIdx.x + 4)];
        gradient[hook(13, 17)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4)];
        gradient[hook(13, 18)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4 + 1)][hook(26, tIdx.x + 4)];
        gradient[hook(13, 19)] += (s - c_d[hook(3, t)]) * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4 + 1)];
      }

      weights[hook(12, 0)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 0)];
      weights[hook(12, 1)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 1)];
      weights[hook(12, 2)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 2)];
      weights[hook(12, 3)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 3)];
      weights[hook(12, 4)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 4)];
      weights[hook(12, 5)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 5)];
      weights[hook(12, 6)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 6)];
      weights[hook(12, 7)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 7)];
      weights[hook(12, 8)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 8)];
      weights[hook(12, 9)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 9)];
      weights[hook(12, 10)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 10)];
      weights[hook(12, 11)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 11)];
      weights[hook(12, 12)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 12)];
      weights[hook(12, 13)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 13)];
      weights[hook(12, 14)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 14)];
      weights[hook(12, 15)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 15)];
      weights[hook(12, 16)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 16)];
      weights[hook(12, 17)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 17)];
      weights[hook(12, 18)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 18)];
      weights[hook(12, 19)] -= n / (float)NUMBER_OF_VOLUMES * gradient[hook(13, 19)];
    }

    ReadSphere((local float*)l_Volume, Volumes, x, y, z, validation, tIdx, DATA_W, DATA_H, DATA_D);

    barrier(0x01);

    float s;
    s = weights[hook(12, 0)] * 1.0f;

    s += weights[hook(12, 1)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4 - 1)];
    s += weights[hook(12, 2)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4 - 1)][hook(17, tIdx.x + 4)];
    s += weights[hook(12, 3)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4)];
    s += weights[hook(12, 4)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4 + 1)][hook(18, tIdx.x + 4)];
    s += weights[hook(12, 5)] * l_Volume[hook(16, tIdx.z + 4 - 1)][hook(15, tIdx.y + 4)][hook(14, tIdx.x + 4 + 1)];

    s += weights[hook(12, 6)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4 - 1)];
    s += weights[hook(12, 7)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4)];
    s += weights[hook(12, 8)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 - 1)][hook(19, tIdx.x + 4 + 1)];
    s += weights[hook(12, 9)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4 - 1)];
    s += weights[hook(12, 10)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4)];
    s += weights[hook(12, 11)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4)][hook(21, tIdx.x + 4 + 1)];
    s += weights[hook(12, 12)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4 - 1)];
    s += weights[hook(12, 13)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4)];
    s += weights[hook(12, 14)] * l_Volume[hook(16, tIdx.z + 4)][hook(20, tIdx.y + 4 + 1)][hook(22, tIdx.x + 4 + 1)];

    s += weights[hook(12, 15)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4 - 1)];
    s += weights[hook(12, 16)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4 - 1)][hook(25, tIdx.x + 4)];
    s += weights[hook(12, 17)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4)];
    s += weights[hook(12, 18)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4 + 1)][hook(26, tIdx.x + 4)];
    s += weights[hook(12, 19)] * l_Volume[hook(16, tIdx.z + 4 + 1)][hook(24, tIdx.y + 4)][hook(23, tIdx.x + 4 + 1)];

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

  Classifier_Performance[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = (float)classification_performance / (float)NUMBER_OF_VOLUMES;
}