//{"height":3,"input_img":0,"out_img":1,"pixels":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void camera_filter(global int* input_img, global int* out_img, int width, int height) {
  int offset, red, green, blue;
  int row = get_global_id(0) / width;
  int col = get_global_id(0) - row * width;
  int4 pixels[3], color_vec;

  int4 k0 = (int4)(-1, -1, 0, 0);
  int4 k1 = (int4)(-1, 0, 1, 0);
  int4 k2 = (int4)(0, 1, 1, 0);

  int denom = 1;

  if ((row > 0) && (col > 0) && (col < width - 2) && (row < height - 1)) {
    offset = (row - 1) * width + (col - 1);
    pixels[hook(4, 0)] = vload4(0, input_img + offset);
    pixels[hook(4, 1)] = vload4(0, input_img + offset + width);
    pixels[hook(4, 2)] = vload4(0, input_img + offset + 2 * width);

    color_vec = ((pixels[hook(4, 0)] & 0x00ff0000) >> 16) * k0 + ((pixels[hook(4, 1)] & 0x00ff0000) >> 16) * k1 + ((pixels[hook(4, 2)] & 0x00ff0000) >> 16) * k2;
    red = clamp((color_vec.s0 + color_vec.s1 + color_vec.s2) / denom, 0, 255);

    color_vec = ((pixels[hook(4, 0)] & 0x0000ff00) >> 8) * k0 + ((pixels[hook(4, 1)] & 0x0000ff00) >> 8) * k1 + ((pixels[hook(4, 2)] & 0x0000ff00) >> 8) * k2;
    green = clamp((color_vec.s0 + color_vec.s1 + color_vec.s2) / denom, 0, 255);

    color_vec = (pixels[hook(4, 0)] & 0x000000ff) * k0 + (pixels[hook(4, 1)] & 0x000000ff) * k1 + (pixels[hook(4, 2)] & 0x000000ff) * k2;
    blue = clamp((color_vec.s0 + color_vec.s1 + color_vec.s2) / denom, 0, 255);

    out_img[hook(1, get_global_id(0))] = 0xff000000 + (red << 16) + (green << 8) + blue;
  } else {
    out_img[hook(1, get_global_id(0))] = input_img[hook(0, get_global_id(0))];
  }
}