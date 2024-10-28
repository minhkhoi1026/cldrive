//{"data":0,"dx":3,"dy":4,"dz":5,"region":1,"unfinished":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int region_index(int z, int y, int x) {
  return z * 512 * 512 + y * 512 + x;
}

int inside(int3 pos) {
  int x = (pos.x >= 0 && pos.x < 512);
  int y = (pos.y >= 0 && pos.y < 512);
  int z = (pos.z >= 0 && pos.z < 512);

  return x && y && z;
}

int similar(global unsigned char* data, int3 a, int3 b) {
  unsigned char va = data[hook(0, a.z * 512 * 512 + a.y * 512 + a.x)];
  unsigned char vb = data[hook(0, b.z * 512 * 512 + b.y * 512 + b.x)];

  int i = abs(va - vb) < 1;
  return i;
}

kernel void region(global unsigned char* data, global unsigned char* region, global int* unfinished) {
  int3 voxel;
  voxel.x = get_global_id(0);
  voxel.y = get_global_id(1);
  voxel.z = get_global_id(2);

  int ind = region_index(voxel.z, voxel.y, voxel.x);

  if (region[hook(1, ind)] == 2) {
    *unfinished = 1;
    region[hook(1, ind)] = 1;

    int dx[6] = {-1, 1, 0, 0, 0, 0};
    int dy[6] = {0, 0, -1, 1, 0, 0};
    int dz[6] = {0, 0, 0, 0, -1, 1};

    for (int n = 0; n < 6; n++) {
      int3 candidate;
      candidate.x = voxel.x + dx[hook(3, n)];
      candidate.y = voxel.y + dy[hook(4, n)];
      candidate.z = voxel.z + dz[hook(5, n)];

      if (!inside(candidate)) {
        continue;
      }

      if (region[hook(1, region_index(candidate.z, candidate.y, candidate.x))]) {
        continue;
      }

      if (similar(data, voxel, candidate)) {
        region[hook(1, region_index(candidate.z, candidate.y, candidate.x))] = 2;
      }
    }
  }
}