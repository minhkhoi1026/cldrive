//{"k":1,"output":0}
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

kernel void perf_kernel(global unsigned int* output, int k) {
  int x = get_global_id(0);
  int y;
  unsigned int sum = 0;
  for (y = 0; y < 0x4fff; y++)
    sum++;

  output[hook(0, y * 16 + x)] = 0x8000 | sum + k * 0x80;
}