//{"FSIZE":5,"Nx":2,"Ny":3,"Nz":4,"input":0,"output":1,"pixLoc":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int localIndex(int i, int j, int k, const int locX, const int locY, const int locZ, const int FSIZE) {
  i += FSIZE;
  j += FSIZE;
  k += FSIZE;

  return i + locX * j + locX * locY * k;
}

kernel void run(read_only image3d_t input, global short* output, const int Nx, const int Ny, const int Nz, const int FSIZE, local short* pixLoc) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  const int workSizeX = get_local_size(0);
  const int workSizeY = get_local_size(1);
  const int workSizeZ = get_local_size(2);
  const int workCubeSize = workSizeX * workSizeY * workSizeZ;

  const int localSizeX = (2 * FSIZE + workSizeX);
  const int localSizeY = (2 * FSIZE + workSizeY);
  const int localSizeZ = (2 * FSIZE + workSizeZ);

  const int localCubeSize = localSizeX * localSizeY * localSizeZ;

  int iGroup = get_local_id(0);
  int jGroup = get_local_id(1);
  int kGroup = get_local_id(2);
  int indexGroup = iGroup + workSizeX * jGroup + workSizeX * workSizeY * kGroup;

  const int ASTRIDE = ceil(1.f * localCubeSize / workCubeSize);

  int4 pos0 = (int4)(get_group_id(0) * workSizeX - FSIZE, get_group_id(1) * workSizeY - FSIZE, get_group_id(2) * workSizeZ - FSIZE, 0);

  for (int k = 0; k < ASTRIDE; ++k) {
    int indexLoc = indexGroup * ASTRIDE + k;
    int tmp = indexLoc;
    int iLoc = tmp % localSizeX;
    tmp = (tmp - iLoc) / localSizeX;
    int jLoc = tmp % localSizeY;
    tmp = (tmp - jLoc) / localSizeY;
    int kLoc = tmp % localSizeZ;

    pixLoc[hook(6, indexLoc)] = read_imageui(input, sampler, pos0 + (int4)(iLoc, jLoc, kLoc, 0)).x;
  }

  barrier(0x01);

  float res = 0;
  float sum = 0;

  int val0 = pixLoc[hook(6, localIndex(iGroup, jGroup, kGroup, localSizeX, localSizeY, localSizeZ, FSIZE))];

  for (int i2 = -FSIZE; i2 <= FSIZE; i2++) {
    for (int j2 = -FSIZE; j2 <= FSIZE; j2++) {
      for (int k2 = -FSIZE; k2 <= FSIZE; k2++) {
        int val1 = pixLoc[hook(6, localIndex(iGroup + i2, jGroup + j2, kGroup + k2, localSizeX, localSizeY, localSizeZ, FSIZE))];

        int dist = (val0 - val1) * (val0 - val1);

        float weight = exp(-1.f / 15.f / 15.f * dist * dist);

        res += val1 * weight;
        sum += weight;
      }
    }
  }

  if (i + j * Nx + k * Nx * Ny < Nx * Ny * Nz)
    output[hook(1, i + j * Nx + k * Nx * Ny)] = (short)(res / sum);
}