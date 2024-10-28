//{"halfBoxHeight":5,"halfBoxWidth":4,"imageHeight":3,"imageWidth":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smp = 0 | 2 | 0x20;
kernel void boxFilter(read_only image2d_t in, write_only image2d_t out, const int imageWidth, const int imageHeight, const int halfBoxWidth, const int halfBoxHeight) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 pos = (int2)(x, y);

  uint4 total = {0, 0, 0, 0};

  int count = 0;

  for (int i = -halfBoxWidth; i <= halfBoxWidth; i++) {
    for (int j = -halfBoxHeight; j <= halfBoxHeight; j++) {
      int2 coord = pos + (int2)(i, j);
      if (coord.x >= 0 && coord.y >= 0 && coord.x < imageWidth && coord.y < imageHeight) {
        total += read_imageui(in, smp, pos + (int2)(i, j));
        count++;
      }
    }
  }
  write_imageui(out, pos, total / count);
}