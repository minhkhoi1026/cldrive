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
kernel void burning_ship(global unsigned int* pixels, global unsigned int* colors, struct kernel_args32 args)

{
  unsigned int i;
  float j_x, j_y;
  float z_x = 0, z_y = 0;
  float d;
  float c_x, c_y;

  int x = args.ofs_x + 4 * get_global_id(0);
  int y = args.ofs_y + 4 * get_global_id(1);

  c_x = args.ofs_lx + x * args.step_x;
  c_y = args.ofs_ty + y * args.step_y;

  i = 0;
  while (i < args.max_iter) {
    if (args.mod1)
      j_x = fabs(z_x * z_x - z_y * z_y) + c_x;
    else
      j_x = z_x * z_x - z_y * z_y + c_x;
    j_y = 2 * fabs(z_x * z_y) + c_y;

    d = (j_x * j_x + j_y * j_y);
    if (d > args.er)
      break;

    z_x = j_x;
    z_y = j_y;
    i++;
  }
  pixels[hook(0, y * 16 + x)] = set_color(args, i, colors);
}