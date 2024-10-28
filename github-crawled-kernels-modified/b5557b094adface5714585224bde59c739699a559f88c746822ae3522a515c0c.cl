//{"height":3,"input":0,"output":1,"vals":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline long indexFromImagePosition(int2 imgpos, unsigned int width, unsigned int height) {
  return imgpos.x + (imgpos.y * width);
}

kernel void fillImage(global uchar* input, global uchar* output, unsigned int width, unsigned int height) {
  int gid = get_global_id(0);
  int gcount = get_global_size(0);
  char d = 21;
  char r = floor(d / 2.0f);
  int2 imgpos = {0, 0};

  imgpos.x = gid % width;
  imgpos.y = floor((float)gid / (float)width);

  int x = max((int)(imgpos.x - r), (int)0);
  int y = max((int)(imgpos.y - r), (int)0);
  int maxX = min((int)(imgpos.x + r), (int)width);
  int maxY = min((int)(imgpos.y + r), (int)height);

  if (input[hook(0, gid)] == 0) {
    uchar vals[255];
    uchar maxVal = 0;
    uchar maxIdx = 0;
    uchar sample;

    for (int i = 0; i < 255; i++)
      vals[hook(4, i)] = 0;

    for (; x <= maxX; x++) {
      for (; y <= maxY; y++) {
        int2 frompos = {x, y};
        long idx = indexFromImagePosition(frompos, width, height);

        if (idx >= gcount)
          continue;

        sample = input[hook(0, idx)];

        vals[hook(4, sample)]++;
      }
    }

    for (int i = 1; i < 255; i++) {
      if (vals[hook(4, i)] > maxVal) {
        maxVal = vals[hook(4, i)];
        maxIdx = i;
      }
    }

    output[hook(1, gid)] = maxIdx;
  } else {
    output[hook(1, gid)] = input[hook(0, gid)];
  }
}