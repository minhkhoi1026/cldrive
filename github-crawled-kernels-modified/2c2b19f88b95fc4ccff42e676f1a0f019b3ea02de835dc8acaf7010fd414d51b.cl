//{"Classifier_Performance":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"EPOCS":10,"Mask":2,"NFEAT":19,"NUMBER_OF_INPUTS":24,"NUMBER_OF_VOLUMES":8,"NperFold":21,"VOXELS_MASK":17,"Volume":25,"Volumes":1,"a":26,"alph":14,"b":27,"c_Correct_Classes":4,"c_d":3,"deltaIndex":16,"fold":20,"kmatrix":18,"n":9,"testIndex":13,"trainIndex":12,"voxbatchoffset":22,"voxbatchsize":23,"voxelIndex1D":15,"x_space":11}
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
  Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x - 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(25, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(1, Calculate4DIndex(x + 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }
}

void normalize_x(global float* x_space, int N, int d);

float doFold(global float* dense_points, global int* trainIndex, global int* testIndex, int d, global float* alpha, constant float* c_Correct_Classes, int trainN, int numExemplos, global const float* kmatrix, int fold, int NperFold);

float dotproduct(global float* a, global float* b, int N) {
  float ret = 0;
  for (int k = 0; k < N; ++k) {
    ret += a[hook(26, k)] * b[hook(27, k)];
  }
  return ret;
}

kernel void CalculateStatisticalMapSearchlight(global float* Classifier_Performance, global const float* Volumes, global const float* Mask, constant float* c_d, constant float* c_Correct_Classes, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private float n, private int EPOCS, global float* x_space, global int* trainIndex, global int* testIndex, global float* alph, global const int* voxelIndex1D, constant int* deltaIndex, private int VOXELS_MASK, global const float* kmatrix, private int NFEAT, private int fold, private int NperFold, private int voxbatchoffset, private int voxbatchsize, private int NUMBER_OF_INPUTS) {
  int voxind = get_global_id(0);

  if (voxind >= voxbatchsize)
    return;

  int voxindWithOffset = voxind + voxbatchoffset;

  int volumeId = voxelIndex1D[hook(15, voxindWithOffset)];

  int x = 41, y = 17, z = 25;
  int testvoxIndex = Calculate3DIndex(x, y, z, DATA_W, DATA_H);

  int SIZ_VOLUME = DATA_W * DATA_H * DATA_D;

  if (volumeId + deltaIndex[hook(16, 0)] < 0 || volumeId + deltaIndex[hook(16, NFEAT - 1)] >= SIZ_VOLUME) {
    Classifier_Performance[hook(0, volumeId)] = 0.0f;
    return;
  }

  int trainN = NUMBER_OF_VOLUMES - NperFold;

  int trainOffset = voxindWithOffset * (NUMBER_OF_VOLUMES - NperFold);
  int testOffset = voxindWithOffset * NperFold;

  float accuracy = doFold(x_space + voxind * NFEAT * NUMBER_OF_VOLUMES * NUMBER_OF_INPUTS, trainIndex + trainOffset, testIndex + testOffset, NFEAT, alph + trainOffset, c_d, trainN, NUMBER_OF_VOLUMES, kmatrix + voxind * NUMBER_OF_VOLUMES * NUMBER_OF_VOLUMES, fold, NperFold);

  Classifier_Performance[hook(0, volumeId)] = Classifier_Performance[hook(0, volumeId)] + accuracy;
}