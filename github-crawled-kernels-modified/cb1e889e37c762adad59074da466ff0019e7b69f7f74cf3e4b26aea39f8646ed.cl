//{"NFEAT":6,"NUMBER_OF_INPUTS":11,"NUMBER_OF_VOLUMES":4,"SIZ_VOLUME":3,"VOXELS_MASK":5,"Volume":12,"Volumes":0,"a":13,"b":14,"deltaIndex":2,"kmatrix":8,"voxbatchoffset":9,"voxbatchsize":10,"voxelIndex1D":1,"x_space":7}
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
  Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(12, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }
}

void normalize_x(global float* x_space, int N, int d);

float doFold(global float* dense_points, global int* trainIndex, global int* testIndex, int d, global float* alpha, constant float* c_Correct_Classes, int trainN, int numExemplos, global const float* kmatrix, int fold, int NperFold);

float dotproduct(global float* a, global float* b, int N) {
  float ret = 0;
  for (int k = 0; k < N; ++k) {
    ret += a[hook(13, k)] * b[hook(14, k)];
  }
  return ret;
}

kernel void PrepareSearchlight(global const float* Volumes, global const int* voxelIndex1D, constant int* deltaIndex, private int SIZ_VOLUME, private int NUMBER_OF_VOLUMES, private int VOXELS_MASK, private int NFEAT, global float* x_space, global float* kmatrix, private int voxbatchoffset, private int voxbatchsize, private int NUMBER_OF_INPUTS)

{
  int voxind = get_global_id(0);

  if (voxind >= voxbatchsize)
    return;

  int volumeId = voxelIndex1D[hook(1, voxind + voxbatchoffset)];

  if (volumeId + deltaIndex[hook(2, 0)] < 0 || volumeId + deltaIndex[hook(2, NFEAT - 1)] >= SIZ_VOLUME) {
    return;
  }

  int x = 41, y = 17, z = 25;
  int DATA_W = 53;
  int DATA_H = 63;
  int testIndex = Calculate3DIndex(x, y, z, DATA_W, DATA_H);

  int voxoffset = voxind * NFEAT * NUMBER_OF_VOLUMES * NUMBER_OF_INPUTS;

  for (int t = 0; t < NUMBER_OF_VOLUMES; t++) {
    for (int c = 0; c < NUMBER_OF_INPUTS; ++c) {
      for (int k = 0; k < NFEAT; k++) {
        x_space[hook(7, t * NFEAT * NUMBER_OF_INPUTS + c * NFEAT + k + voxoffset)] = Volumes[hook(0, volumeId + deltaIndex[khook(2, k) + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)];
      }
    }
  }

  x_space = x_space + voxoffset;
  kmatrix = kmatrix + voxind * NUMBER_OF_VOLUMES * NUMBER_OF_VOLUMES;

  for (int a = 0; a < NUMBER_OF_VOLUMES; ++a) {
    for (int b = 0; b < NUMBER_OF_VOLUMES; ++b) {
      kmatrix[hook(8, a + b * NUMBER_OF_VOLUMES)] = dotproduct(x_space + a * NFEAT * NUMBER_OF_INPUTS, x_space + b * NFEAT * NUMBER_OF_INPUTS, NFEAT * NUMBER_OF_INPUTS);
    }
  }
}