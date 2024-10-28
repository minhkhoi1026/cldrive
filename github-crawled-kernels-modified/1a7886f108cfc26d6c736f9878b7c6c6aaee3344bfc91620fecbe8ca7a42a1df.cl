//{"Nx":2,"Ny":3,"Nz":4,"input":0,"output":1,"pixLoc":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int localIndex(int i, int j, int k, const int locX, const int locY, const int locZ) {
  i += 2;
  j += 2;
  k += 2;

  return i + locX * j + locX * locY * k;
}

kernel void run(read_only image3d_t input, global short* output, const int Nx, const int Ny, const int Nz) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  const int workSizeX = get_local_size(0);
  const int workSizeY = get_local_size(1);
  const int workSizeZ = get_local_size(2);
  const int workCubeSize = workSizeX * workSizeY * workSizeZ;

  const int localSizeX = (2 * 2 + workSizeX);
  const int localSizeY = (2 * 2 + workSizeY);
  const int localSizeZ = (2 * 2 + workSizeZ);

  const int localCubeSize = localSizeX * localSizeY * localSizeZ;

  int iGroup = get_local_id(0);
  int jGroup = get_local_id(1);
  int kGroup = get_local_id(2);
  int indexGroup = iGroup + workSizeX * jGroup + workSizeX * workSizeY * kGroup;

  const int ASTRIDE = ceil(1.f * localCubeSize / workCubeSize);

  int4 pos0 = (int4)(get_group_id(0) * workSizeX - 2, get_group_id(1) * workSizeY - 2, get_group_id(2) * workSizeZ - 2, 0);

  local float pixLoc[2001];

  for (int k = 0; k < ASTRIDE; ++k) {
    int indexLoc = indexGroup * ASTRIDE + k;
    int tmp = indexLoc;
    int iLoc = tmp % localSizeX;
    tmp = (tmp - iLoc) / localSizeX;
    int jLoc = tmp % localSizeY;
    tmp = (tmp - jLoc) / localSizeY;
    int kLoc = tmp % localSizeZ;

    pixLoc[hook(5, indexLoc)] = read_imageui(input, sampler, pos0 + (int4)(iLoc, jLoc, kLoc, 0)).x;
  }

  barrier(0x01);

  float res = 0;
  float sum = 0;

  float val0 = pixLoc[hook(5, localIndex(iGroup, jGroup, kGroup, localSizeX, localSizeY, localSizeZ))];

  for (int i2 = -2; i2 <= 2; i2++) {
    for (int j2 = -2; j2 <= 2; j2++) {
      for (int k2 = -2; k2 <= 2; k2++) {
        float val1 = pixLoc[hook(5, localIndex(iGroup + i2, jGroup + j2, kGroup + k2, localSizeX, localSizeY, localSizeZ))];

        float dist = val0 - val1;

        float weight = exp(-1.f / 15.f / 15.f * dist * dist);

        res += val1 * weight;
        sum += weight;
      }
    }
  }

  if (i + j * Nx + k * Nx * Ny < Nx * Ny * Nz)
    output[hook(1, i + j * Nx + k * Nx * Ny)] = (short)(res / sum);
}