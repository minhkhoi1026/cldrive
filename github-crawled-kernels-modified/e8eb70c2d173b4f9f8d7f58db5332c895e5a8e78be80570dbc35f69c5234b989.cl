//{"args":2,"colors":1,"pixels":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct kernel_args32 {
  unsigned int rgb;
  unsigned int mm;
  float ofs_lx;
  float ofs_rx;
  float ofs_ty;
  float ofs_by;
  float step_x;
  float step_y;
  float er;
  unsigned int max_iter;
  int pal;
  float c_x, c_y;
  int ofs_x, ofs_y;
  float c1[3], c2[3], c3[3], c4[3];
  int mod1;
  int post_process;
};
unsigned int set_color(struct kernel_args32 args, unsigned int i, global unsigned int* colors);
kernel void dragon(global unsigned int* pixels, global unsigned int* colors, struct kernel_args32 args)

{
  int px = get_global_id(0);
  int py = get_global_id(1);

  int x, y;
  unsigned int r;
  float x1 = 0, y1 = 0;
  float xc = 0, yc = 0;

  if (px == 0 && py == 0) {
    for (r = 0; r < args.max_iter; r++) {
      int select_move = 0;

      if (cos(3.14f * sin(1.0f * r * r)) > args.er)
        select_move = 1;

      if (select_move) {
        x1 = -0.3 * xc - 1.0 + (args.c_x - 0.15f);
        y1 = -0.3 * yc + 0.1 + (args.c_y + 0.60f);
      } else {
        x1 = 0.76 * xc - 0.4 * yc + (args.c_x - 0.15f);
        y1 = 0.4 * xc + 0.76 * yc + (args.c_y + 0.60f);
      }
      xc = x1;
      yc = y1;
      x = (args.ofs_lx + x1) / args.step_x;
      y = (args.ofs_ty + y1) / args.step_y;
      if (x < 16 / 2 && y < 128 / 2 && x > -16 / 2 && y > -128 / 2) {
        pixels[hook(0, (128 / 2 - y) * 16 + 16 / 2 + x)] = 0xff0000 | r * args.mm | args.rgb;
      }
    }
  }
}