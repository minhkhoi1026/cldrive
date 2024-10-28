//{"data":0,"dx":3,"dy":4,"dz":5,"finished":1,"region":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int ps5_inside(int3 pos) {
  int x = (pos.x >= 0 && pos.x < 512);
  int y = (pos.y >= 0 && pos.y < 512);
  int z = (pos.z >= 0 && pos.z < 512);

  return x && y && z;
}

int ps5_similar(unsigned char* data, int3 a, int3 b) {
  unsigned char va = data[hook(0, a.z * 512 * 512 + a.y * 512 + a.x)];
  unsigned char vb = data[hook(0, b.z * 512 * 512 + b.y * 512 + b.x)];

  int i = abs(va - vb) < 1;
  return i;
}

kernel void region(global unsigned char* data, global int* finished, global unsigned char* region) {
  int id = get_global_id(0);
  int x = id % 512;
  int y = id / 512;
  int z = id / (512 * 512);

  int dx[6] = {-1, 1, 0, 0, 0, 0};
  int dy[6] = {0, 0, -1, 1, 0, 0};
  int dz[6] = {0, 0, 0, 0, -1, 1};

  int3 pixel;
  pixel.x = x;
  pixel.y = y;
  pixel.z = z;
  for (int i = 0; i < 40; i++) {
    if (region[hook(2, pixel.z * 512 * 512 + pixel.y * 512 + pixel.x)] == 2) {
      region[hook(2, pixel.z * 512 * 512 + pixel.y * 512 + pixel.x)] = 1;
      for (int n = 0; n < 6; n++) {
        int3 candidate = pixel;
        candidate.x += dx[hook(3, n)];
        candidate.y += dy[hook(4, n)];
        candidate.z += dz[hook(5, n)];

        if (!ps5_inside(candidate)) {
          continue;
        }

        if (region[hook(2, candidate.z * 512 * 512 + candidate.y * 512 + candidate.x)]) {
          continue;
        }

        if (ps5_similar(*data, pixel, candidate)) {
          region[hook(2, candidate.z * 512 * 512 + candidate.y * 512 + candidate.x)] = 2;
          finished[hook(1, 0)] = 0;
        }
      }
    }
  }
}