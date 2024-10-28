//{"field":0,"height":3,"img_out":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void drawScreen(global float* field, write_only image2d_t img_out, int width, int height) {
  const int2 ipos = (int2)(get_global_id(0), get_global_id(1));
  const int4 pos = (int4)(get_global_id(0), get_global_id(1), 1, 0);
  const int4 int2 = (int4)(get_global_id(0), get_global_id(1), 1, 0);
  float v = field[hook(0, pos.x + pos.y * width + pos.z * width * height)];
  float v2 = field[hook(0, pos.x + pos.y * width + int2.z * width * height)];
  int r = (int)(v * 200.0f);
  int g = (int)(v * 56.0f);
  int b = (int)(v * 10.f);
  if (r > 255.0f)
    r = 255.0f;
  if (g > 255.0f)
    g = 255.0f;
  if (b > 255.0f)
    b = 255.0f;
  write_imageui(img_out, ipos, (uint4)(r, g, b, 255));
}