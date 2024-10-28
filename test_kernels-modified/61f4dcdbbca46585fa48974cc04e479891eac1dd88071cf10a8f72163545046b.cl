//{"depth":2,"direction":5,"height":4,"input":0,"output":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline long indexFromImagePosition(int2 imgpos, unsigned int width, unsigned int height) {
  return imgpos.x + (imgpos.y * width);
}

kernel void anaglyph(global uchar* input, global uchar* output, global uchar* depth, unsigned int width, unsigned int height, int direction) {
  int gid = get_global_id(0);
  size_t gsize = get_global_size(0);

  int2 imgpos = {0, 0};
  int2 mypos;

  imgpos.x = gid % width;
  imgpos.y = floor((float)gid / (float)width);

  mypos = imgpos;

  mypos.x += direction * ((255 - depth[hook(2, gid)]) * 0.2);
  mypos.x = max(min((float)mypos.x, (float)width), 0.0f);

  long idx = indexFromImagePosition(mypos, width, height);

  if (idx < gsize) {
    output[hook(1, gid)] = input[hook(0, idx)];
  } else {
    output[hook(1, gid)] = input[hook(0, gid)];
  }
}