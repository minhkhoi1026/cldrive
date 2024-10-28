//{"result":1,"size":2,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void dilate2D(read_only image2d_t volume, write_only image2d_t result, private int size) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const int width = get_image_width(result);
  const int height = get_image_height(result);

  if (read_imageui(volume, sampler, pos).x == 1) {
    char write = 0;
    for (int a = -size; a <= size; a++) {
      for (int b = -size; b <= size; b++) {
        int2 n = (int2)(a, b);
        if (length(convert_float2(n)) <= size && pos.x + a >= 0 && pos.x + a < width && pos.y + b >= 0 && pos.y + b < height)
          write_imageui(result, pos + n, 1);
      }
    }
  }
}