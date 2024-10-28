//{"buckets":5,"height":4,"input":0,"output":1,"q":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline long indexFromImagePosition(int2 imgpos, unsigned int width, unsigned int height, unsigned int buckets, unsigned int currentBucket) {
  return currentBucket + (imgpos.x * buckets) + (imgpos.y * width * buckets);
}

kernel void reduceImage(global uchar* input, global uchar* output, global uchar* q, unsigned int width, unsigned int height, unsigned int buckets) {
  int gid = get_global_id(0);
  int2 imgpos = {0, 0};

  imgpos.x = gid % width;
  imgpos.y = floor((float)gid / (float)width);

  q[hook(2, gid)] = output[hook(1, gid)] = 0;

  long btot = 0;

  for (unsigned int i = 0; i < buckets; i++) {
    uchar bval = input[hook(0, indexFromImagePosition(imgpos, width, height, buckets, i))];

    btot += bval;

    if (bval > q[hook(2, gid)]) {
      q[hook(2, gid)] = bval;
      output[hook(1, gid)] = i;
    }
  }

  output[hook(1, gid)] = (output[hook(1, gid)] + 1);

  if (!(btot > (1.0 * q[hook(2, gid)]))) {
    output[hook(1, gid)] = q[hook(2, gid)] = 0;
  }
}