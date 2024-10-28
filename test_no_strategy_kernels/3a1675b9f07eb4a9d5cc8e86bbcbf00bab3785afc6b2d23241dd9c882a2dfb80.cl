//{"NUMBER_OF_INPUTS":5,"NUMBER_OF_VOLUMES":2,"SIZ_VOLUME":3,"VOXELS_MASK":4,"Volume":6,"Volumes":0,"voxelIndex1D":1}
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
  Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;
  Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = 0.0f;

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y - 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z - 4) < DATA_D) && ((z - 4) >= 0)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y + 4, z - 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y - 4) < DATA_H) && ((y - 4) >= 0) && ((z + 4) < DATA_D)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y - 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x - 4) < DATA_W) && ((x - 4) >= 0) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x - 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }

  if (((x + 4) < DATA_W) && ((y + 4) < DATA_H) && ((z + 4) < DATA_D)) {
    Volume[hook(6, Calculate3DIndex(tIdx.x + 8, tIdx.y + 8, tIdx.z + 8, 16, 16))] = Volumes[hook(0, Calculate4DIndex(x + 4, y + 4, z + 4, t, DATA_W, DATA_H, DATA_D))];
  }
}

void normalize_x(global float* x_space, int N, int d);

float doFold(global float* dense_points, global int* trainIndex, global int* testIndex, int d, global float* alpha, constant float* c_Correct_Classes, int trainN, int numExemplos, global const float* kmatrix, int fold, int NperFold);

kernel void PrepareInputSearchlight(global float* Volumes, global const int* voxelIndex1D, private int NUMBER_OF_VOLUMES, private int SIZ_VOLUME, private int VOXELS_MASK, private int NUMBER_OF_INPUTS) {
  int voxind = get_global_id(0);
  int volumeId = voxelIndex1D[hook(1, voxind)];

  if (voxind >= VOXELS_MASK)
    return;

  float eps = 0.00001;
  float minimum = Volumes[hook(0, volumeId)];
  float maximum = minimum;

  int x = 41, y = 17, z = 25;
  int DATA_W = 53;
  int DATA_H = 63;
  int testIndex = Calculate3DIndex(x, y, z, DATA_W, DATA_H);

  for (int c = 0; c < NUMBER_OF_INPUTS; ++c) {
    for (int t = 0; t < NUMBER_OF_VOLUMES; ++t) {
      if (Volumes[hook(0, volumeId + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)] > maximum)
        maximum = Volumes[hook(0, volumeId + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)];
      if (Volumes[hook(0, volumeId + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)] < minimum)
        minimum = Volumes[hook(0, volumeId + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)];
    }
  }

  float scale = 2 / (maximum - minimum);
  float minimum_scaled = minimum * scale;

  if ((maximum - minimum) < eps) {
    scale = 1;
    minimum_scaled = 0;

    if (fabs(maximum) > eps) {
      scale = 1 / maximum;
      minimum_scaled = 0;
    }
  }

  for (int c = 0; c < NUMBER_OF_INPUTS; ++c) {
    for (int t = 0; t < NUMBER_OF_VOLUMES; ++t) {
      Volumes[hook(0, volumeId + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)] = Volumes[hook(0, volumeId + t * SIZ_VOLUME + c * SIZ_VOLUME * NUMBER_OF_VOLUMES)] * scale - minimum_scaled - 1.;
    }
  }
}