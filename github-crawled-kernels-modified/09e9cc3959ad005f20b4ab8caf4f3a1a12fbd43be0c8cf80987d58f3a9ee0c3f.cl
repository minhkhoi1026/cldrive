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
kernel void julia_full(global unsigned int* pixels, global unsigned int* colors, struct kernel_args32 args)

{
  unsigned int i;
  float j_x, j_y;
  float z_julia_x, z_julia_y, d;

  int x = get_global_id(0);
  int y = get_global_id(1);

  z_julia_x = args.ofs_lx + x * args.step_x;
  z_julia_y = args.ofs_ty + y * args.step_y;

  i = 0;
  while (i < args.max_iter) {
    j_x = z_julia_x * z_julia_x - z_julia_y * z_julia_y + args.c_x;
    j_y = 2 * z_julia_x * z_julia_y + args.c_y;
    d = (j_x * j_x + j_y * j_y);
    if (d > args.er)
      break;
    z_julia_x = j_x;
    z_julia_y = j_y;
    i++;
  }
  pixels[hook(0, y * 16 + x)] = set_color(args, i, colors);
}