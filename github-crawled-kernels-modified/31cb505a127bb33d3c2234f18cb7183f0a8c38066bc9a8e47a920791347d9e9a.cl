//{"image":0,"rays":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void lineSearch(read_only image2d_t image, global unsigned int* rays) {
  const int i = get_global_id(0);
  unsigned int result = 0;
  const int width = get_image_width(image);
  const int height = get_image_height(image);

  if (i < width) {
    for (int y = height / 6; y < height * 5 / 6; ++y) {
      int2 position = {i, y};
      if (read_imageui(image, sampler, position).x > 0) {
        result += 1;
      }
    }
  } else {
    for (int x = width / 6; x < width * 5 / 6; ++x) {
      int2 position = {x, i - width};
      if (read_imageui(image, sampler, position).x > 0) {
        result += 1;
      }
    }
  }

  rays[hook(1, i)] = result;
}