//{"dst_buf":1,"height":3,"in_buf":7,"num_steps":4,"offset_x":5,"offset_y":6,"src_buf":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 get_pixel_color(const global float4* in_buf, int width, int height, int x, int y) {
  int ix = clamp(x, 0, width - 1);
  int iy = clamp(y, 0, height - 1);

  return in_buf[hook(7, iy * width + ix)];
}

kernel void motion_blur(global const float4* src_buf, global float4* dst_buf, int width, int height, int num_steps, float offset_x, float offset_y) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  float4 sum = 0.0f;

  for (int step = 0; step < num_steps; step++) {
    float t = num_steps == 1 ? 0.0f : step / (float)(num_steps - 1) - 0.5f;

    float xx = gidx + t * offset_x;
    float yy = gidy + t * offset_y;

    int ix = (int)floor(xx);
    int iy = (int)floor(yy);

    float dx = xx - floor(xx);
    float dy = yy - floor(yy);

    float4 mixy0, mixy1, pix0, pix1, pix2, pix3;

    pix0 = get_pixel_color(src_buf, width, height, ix, iy);
    pix1 = get_pixel_color(src_buf, width, height, ix + 1, iy);
    pix2 = get_pixel_color(src_buf, width, height, ix, iy + 1);
    pix3 = get_pixel_color(src_buf, width, height, ix + 1, iy + 1);

    mixy0 = dy * (pix2 - pix0) + pix0;
    mixy1 = dy * (pix3 - pix1) + pix1;

    sum += dx * (mixy1 - mixy0) + mixy0;
  }

  dst_buf[hook(1, gidy * width + gidx)] = sum / num_steps;
}