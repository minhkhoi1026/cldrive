//{"buckets":4,"currentBucket":5,"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline long indexFromImagePosition(int2 imgpos, unsigned int width, unsigned int height, unsigned int buckets, unsigned int currentBucket) {
  return currentBucket + (imgpos.x * buckets) + (imgpos.y * width * buckets);
}

kernel void mergeImages(global uchar* input, global uchar* output, unsigned int width, unsigned int height, unsigned int buckets, unsigned int currentBucket) {
  int gid = get_global_id(0);
  int2 imgpos = {0, 0};

  imgpos.x = gid % width;
  imgpos.y = floor((float)gid / (float)width);

  output[hook(1, indexFromImagePosition(imgpos, width, height, buckets, currentBucket))] = input[hook(0, gid)];
}