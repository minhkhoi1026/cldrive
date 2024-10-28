//{"firstLevel":1,"image":0,"offset2D":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int2 offset2D[4] = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};

constant int4 offset3D[8] = {{0, 0, 0, 0}, {1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {1, 1, 1, 0}, {0, 1, 1, 0}, {1, 1, 0, 0}};

constant sampler_t sampler = 0 | 0 | 0x10;

kernel void createFirstSumImage2DLevel(read_only image2d_t image, write_only image2d_t firstLevel) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const int2 readPos = pos * 2;
  const int2 size = {get_image_width(image), get_image_height(image)};

  float sum = 0.0f;
  for (int i = 0; i < 4; i++) {
    int2 nPos = readPos + offset2D[hook(2, i)];
    if (nPos.x < size.x && nPos.y < size.y) {
      sum += read_imagei(image, sampler, nPos).x;
    }
  }

  write_imagef(firstLevel, pos, sum);
}