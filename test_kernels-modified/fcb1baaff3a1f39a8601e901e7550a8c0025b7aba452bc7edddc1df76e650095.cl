//{"answer":1,"data":0,"heightMap":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int nextInt(ulong* seed, short bound);
int next(ulong* seed, short bits);
int nextIntUnknown(ulong* seed, short bound);
unsigned char extract(const unsigned int heightMap[], int id);
void increase(unsigned int heightMap[], int id, int val);
kernel void crack(global int* data, global ulong* answer) {
  int id = get_global_id(0);
  ulong originalSeed = (((ulong)data[hook(0, 0)] * (ulong)data[hook(0, 1)] + (ulong)id) << 4) | data[hook(0, 8)];
  ulong seed = originalSeed;

  short position = -1;
  short posMap;
  short posX, posY, posZ;
  short initialPosX, initialPosY, initialPosZ, initialPos;
  short top = data[hook(0, 7)];

  unsigned int heightMap[205];

  for (short i = 0; i < 205; i++) {
    heightMap[hook(2, i)] = 0;
  }

  for (short i = 0; i < 10; i++) {
    if (20 - top > 9 * (10 - i)) {
      return;
    }

    initialPosX = next(&seed, 4) + 8;
    initialPosZ = next(&seed, 4) + 8;
    initialPos = initialPosX + initialPosZ * 32;

    short terrainHeight = (extract(heightMap, initialPos) + 63 + 1) * 2;
    initialPosY = nextIntUnknown(&seed, terrainHeight);

    if (initialPosY + 3 <= 63 && initialPosY - 3 >= 0) {
      seed = (seed * 256682821044977UL + 233843537749372UL) & ((1UL << 48) - 1);
      continue;
    }
    if (initialPosY - 3 > top + 63 + 1) {
      for (int j = 0; j < 10; j++) {
        seed = (seed * 76790647859193UL + 25707281917278UL) & ((1UL << 48) - 1);
        nextIntUnknown(&seed, nextInt(&seed, 3) + 1);
      }
      continue;
    }

    for (short a = 0; a < 10; a++) {
      posX = initialPosX + next(&seed, 3) - next(&seed, 3);
      posY = initialPosY + next(&seed, 2) - next(&seed, 2);
      posZ = initialPosZ + next(&seed, 3) - next(&seed, 3);
      posMap = posX + posZ * 32;

      if (position == -1 && posY > 63 && posY <= 63 + data[hook(0, 7)] + 1) {
        if (posMap == data[hook(0, 3)]) {
          position = 0;
        } else if (posMap == data[hook(0, 4)]) {
          position = 1;
        } else if (posMap == data[hook(0, 5)]) {
          position = 2;
        }

        if (position != -1) {
          int bit = (int)((originalSeed >> 4) & 1);

          if (data[hook(0, 6)] != position) {
            if (bit == data[hook(0, 9)])
              return;
          } else {
            if (bit != data[hook(0, 9)])
              return;
          }

          increase(heightMap, posMap, data[hook(0, 7)]);
          top = data[hook(0, 7)];
        }
      }

      if (posY <= extract(heightMap, posMap) + 63)
        continue;

      short offset = 1 + nextIntUnknown(&seed, nextInt(&seed, 3) + 1);

      for (short j = 0; j < offset; j++) {
        if ((posY + j - 1) > extract(heightMap, posX + posZ * 32) + 63 || posY < 0)
          continue;
        if ((posY + j) <= extract(heightMap, (posX + 1) + posZ * 32) + 63)
          continue;
        if ((posY + j) <= extract(heightMap, (posX - 1) + posZ * 32) + 63)
          continue;
        if ((posY + j) <= extract(heightMap, posX + (posZ + 1) * 32) + 63)
          continue;
        if ((posY + j) <= extract(heightMap, posX + (posZ - 1) * 32) + 63)
          continue;

        increase(heightMap, posMap, 1);

        if (top < extract(heightMap, posMap)) {
          top = extract(heightMap, posMap);
        }
      }
    }
  }
  if (top >= 20) {
    answer[hook(1, atomic_add(&data[2hook(0, 2), 1))] = ((ulong)top) << 58UL | (((ulong)data[hook(0, position + 3)]) << 48UL) | originalSeed;
  }
}