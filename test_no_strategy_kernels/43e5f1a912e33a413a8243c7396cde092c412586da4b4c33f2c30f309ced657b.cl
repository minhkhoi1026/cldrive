//{"gaussian":2,"height":4,"input":0,"output":1,"size":5,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline long indexFromImagePosition(int2 imgpos, unsigned int width, unsigned int height) {
  return imgpos.x + (imgpos.y * width);
}

kernel void contrastFilter(global uchar* input, global uchar* output, global float* gaussian, unsigned int width, unsigned int height, unsigned int size) {
  long gid = get_global_id(0);
  size_t gsize = get_global_size(0);

  char r = floor(size * 0.5f);
  int2 imgpos = {0, 0};

  imgpos.x = gid % width;
  imgpos.y = floor((float)gid / (float)width);

  float total = 0;
  uchar value = input[hook(0, gid)], sample;

  int x = max((int)(imgpos.x - r), (int)0);
  int y = max((int)(imgpos.y - r), (int)0);
  int maxX = min((int)(imgpos.x + r), (int)width);
  int maxY = min((int)(imgpos.y + r), (int)height);

  float totalCount = 0;

  float sinvsq = 36.0 / ((1.0 + 2.0 * r) * (1.0 + 2.0 * r));

  for (; x <= maxX; x++) {
    for (; y <= maxY; y++) {
      int2 frompos = {x, y};
      long index = indexFromImagePosition(frompos, width, height);

      if (index < 0 || index > gsize) {
        continue;
      }

      sample = input[hook(0, index)];

      float gval = native_exp((float)-((0.5f * ((x - imgpos.x) * (x - imgpos.x)) * sinvsq) + (0.5f * ((y - imgpos.y) * (y - imgpos.y)) * sinvsq)));

      total += abs(sample - value) * gval;
      totalCount += gval;
    }
  }

  output[hook(1, gid)] = (uchar)(total / totalCount);
}