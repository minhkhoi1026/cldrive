//{"dest":0,"dest_step":2,"vert":1,"vert_step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) kernel void scan2_F64(global double* dest, global double* vert, int dest_step, int vert_step) {
  dest_step /= sizeof(double);
  vert_step /= sizeof(double);

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);

  double Sum = 0;
  for (int i = 0; i <= gx; i++) {
    double v = dest[hook(0, gy * dest_step + (i + 1) * 8 * 8 - 1)];
    Sum += v;
  }

  vert[hook(1, gy * vert_step + gx)] = Sum;
}